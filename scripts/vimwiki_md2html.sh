#!/usr/bin/env bash
set -e;

PANDOC=$(which pandoc)


# The following arguments, in this order, are passed to the script:
# 
# 1. force : [0/1] overwrite an existing file
# 2. syntax : the syntax chosen for this wiki
# 3. extension : the file extension for this wiki
# 4. output_dir : the full path of the output directory
# 5. input_file : the full path of the wiki page
# 6. css_file : the full path of the css file for this wiki

# shellcheck disable=SC2034  # FORCE appears unused
FORCE="$1"
SYNTAX="$2"
EXTENSION="$3"
OUTPUTDIR="$4"
INPUT="$5"
CSSFILE="$6"
TEMPLATE_PATH="$7"
TEMPLATE_DEFAULT="$8"
# This is prefixed with '.' already
TEMPLATE_EXT="$9"

# == The following aren't handled:
#
# 10. root_path : a count of ../ for pages buried in subdirs
#     For example, if you have wikilink [[dir1/dir2/dir3/my page in a subdir]]
#     then this argument is '../../../'.
# 11. custom_args : custom arguments that will be passed to the conversion
#     (can be defined in g:vimwiki_list as 'custom_wiki2html_args' parameter,
#     see |vimwiki-option-custom_wiki2html_args|)
#     script.

if [[ "$SYNTAX" != "markdown" ]]; then
  echo "error: Unsupported syntax '${SYNTAX}'" >&2;
  exit 1;
fi

# Ensure that output directory exists
mkdir -p $OUTPUTDIR

OUTPUT="$OUTPUTDIR/$(basename "$INPUT" ."$EXTENSION").html"

OUTPUTTMP=$(dirname "$INPUT")/$(basename "$INPUT" ."$EXTENSION").html

TEMPLATE="${TEMPLATE_PATH}/${TEMPLATE_DEFAULT}${TEMPLATE_EXT}"

# Cleaned up on script exit
METADATA_TMPFILE=$(mktemp)
# shellcheck disable=SC2064. The eager expansion is intentional.
trap "rm -rf $METADATA_TMPFILE" EXIT

# This extracts the first YAML frontmatter in a block between two '---'
awk  'BEGIN { state = 0 }; /---/ { state +=1; next} state == 1' "$INPUT" > "$METADATA_TMPFILE"

if [[ -f "$TEMPLATE" ]]; then
  $PANDOC --toc \
    --standalone \
    --mathjax \
    --section-divs \
    --highlight-style=tango \
    --email-obfuscation=references \
    --metadata-file "$METADATA_TMPFILE" \
    --template "${TEMPLATE}" \
    --css="$CSSFILE" \
    -f gfm \
    -t html \
    "$INPUT" \
    -o "$OUTPUTTMP" 2>/dev/null
else
  $PANDOC --toc \
    --standalone \
    --mathjax \
    --section-divs \
    --highlight-style=pygments \
    --email-obfuscation=references \
    --metadata-file "$METADATA_TMPFILE" \
    --css="$CSSFILE" \
    -f "$SYNTAX" \
    -f gfm \
    -t html \
    "$INPUT" \
    -o "$OUTPUTTMP" 2>/dev/null
fi

# Clean up the output HTML, by appending ".html" to links that don't end in it
sed -i -e 's/\(href\s*=\s*\)"\([^#].\+\?[^(.css|.html)]\)"/\1"\2.html"/g' "$OUTPUTTMP"

mv -f "$OUTPUTTMP" "$OUTPUT"
