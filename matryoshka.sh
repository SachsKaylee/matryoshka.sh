#!/usr/bin/env bash
SOURCE="$1"
OUTPUT="$2"
MAX_ITERATIONS="${3:-10}"
ITERATIONS="0"
DELETE_SOURCE="false"

set -e

# ACTUAL WRAPPING

function wrap_zip {
  echo "... wrapping in ZIP"
  OUTPUT="$OUTPUT.zip"
  zip -r "$OUTPUT" "$SOURCE"
}

function wrap_tar {
  echo "... wrapping in TAR"
  OUTPUT="$OUTPUT.tar"
  tar -cvf "$OUTPUT" "$SOURCE"
}

function wrap_gz() {
  __RAND=$((1 + $RANDOM % 2))
  gzip -k "$SOURCE" > "$OUTPUT" 
}

function wrap_random {
  __RAND=$((1 + $RANDOM % 2))
  echo "... wrap random is: $__RAND"
  case $__RAND in
    1)
      wrap_zip
      ;;
    2)
      wrap_tar
      ;;
    3)
      wrap_gz
      ;;
  esac
}

# FAKE

function fake_rar {
  OUTPUT="$OUTPUT.rar"
  cp -r "$SOURCE" "$OUTPUT"
}

function fake_gz {
  OUTPUT="$OUTPUT.gz"
  cp -r "$SOURCE" "$OUTPUT"
}

function fake_7z {
  OUTPUT="$OUTPUT.gz"
  cp -r "$SOURCE" "$OUTPUT"
}

function fake_zip {
  OUTPUT="$OUTPUT.rar"
  cp -r "$SOURCE" "$OUTPUT"
}

function fake_random {
  __RAND=$((1 + $RANDOM % 4))
  echo "... fake random is: $__RAND"
  case $__RAND in
    1)
      fake_rar
      ;;
    2)
      fake_gz
      ;;
    3)
      fake_7z
      ;;
    4)
      fake_zip
      ;;
  esac
}

# ACTUAL

function do_random {
  __RAND=$((1 + $RANDOM % 4))
  case $__RAND in
    1)
      fake_random
      ;;
    2 | 3 | 4)
      wrap_random
      ;;
  esac

}

function iterate {
  echo "Wrapping (iteration $ITERATIONS/$MAX_ITERATIONS)..."
  do_random
  if [ "$DELETE_SOURCE" = "true" ]; then
    rm -vr "$SOURCE"
  fi
  SOURCE="$OUTPUT"
  DELETE_SOURCE="true"
  ITERATIONS=$((ITERATIONS + 1))
  if [ "$ITERATIONS" = "$MAX_ITERATIONS" ]; then
    echo "Finished wrapping..."
    exit 0
  fi
  iterate
}

iterate

echo "DONE - Filename is: $OUTPUT"
