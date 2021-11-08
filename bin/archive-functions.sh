#!/bin/bash
#Requires:
# gettext-base package for envsubst
# xz-utils package for xz tools
# bzip2 package for bzip2 tools
# gzip package for gzip tools
# zstd package for zstd tools
# libarchive package for bsdtar tools
# tar package for tar tools
# zip package for zip tools

un_gzip_toconsole='gzip -d -k -f -c -- ${file_name}'
un_xz_toconsole='xz -d -k -f -c -- ${file_name}' #-v for progress
un_bzip2_toconsole='bzip2 -d -k -f -c -- ${file_name}'
un_zstd_toconsole='zstd -q -d -k -f -c -- ${file_name}' #zstd can also decompress gzip, xz, lzma and lz4
un_zip_toconsole='unzip -o -p -- ${file_name}'

#un_tar='tar -xf ${file_name}'
#un_zip_to_console
cat='cat -- ${file_name}'

function get_file_extension ( )
{
  local fullfile=$*
  local filename
  local extension
  filename=$(basename -- "${fullfile}")
  extension="${filename#*.}"
  echo ".${extension}"
}

function get_file_name_no_extension ( )
{
  local fullfile=$*
  local extension
  local filename
  extension=$(get_file_extension "${fullfile}")
  filename=${fullfile%${extension}}
  echo "${filename}"
}

function get_unpack_toconsole_command_single_file_archive ( )
{
  local fullfile=$*
  local extension
  local filename
  extension=$(get_file_extension "${fullfile}")
  filename=$(get_file_name_no_extension "${fullfile}")
  local ret=""

  case "$extension" in
#    tar.gz|tar.gzip|tgz)
#      echo tar.gz
#    ;;
#    tar.xz|txz)
#      echo tar.xz
#    ;;
#    tar.bz2|tar.bzip2|tbz|tbz2)
#      echo tar.bz2
#    ;;
    *.tar.*|*.tar)
      echo "Unsupported suffix \"${extension}\" for file \"$fullfile\"" >&2
      return 1
    ;;
    *.zip)
      ret=${un_zip_toconsole}
    ;;
    *.gz|*.gzip)
      ret=${un_gzip_toconsole}
    ;;
    *.xz)
      ret=${un_xz_toconsole}
    ;;
    *.bz2|*.bzip2)
      ret=${un_bzip2_toconsole}
    ;;
    *.zst)
      ret=${un_zstd_toconsole}
    ;;
    *.img|*.bin|*.raw|*.iso)
      ret=${cat}
    ;;
    *)
      echo "Unsupported suffix \"${extension}\" for file \"$fullfile\"" >&2
      return 1
    ;;
  esac
  file_name=${fullfile} envsubst <<< "${ret}"
  return 0
}
