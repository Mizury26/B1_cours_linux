#!/bin/bash
# lil script to dl a yt video passed as argument
# it4 29/11/2022

GR='\e[32m'
RE='\e[31m'
YE='\e[33m'
BO='\e[1m'
NC='\e[0m'

log() {
  log_level="${1}"
  log_message="${2}"

  if [[ "${log_level}" == 'error' ]] ; then
    echo -e "${RE}${BO}[ERROR]${NC} ${log_message}"

  elif [[ "${log_level}" == 'warn' ]] ; then
    echo -e "${YE}${BO}[WARN]${NC} ${log_message}"

  elif [[ "${log_level}" == 'ok' ]] ; then
    echo -e "${GR}${BO}[OK]${NC} ${log_message}"

  elif [[ "${log_level}" == 'info' ]] ; then
    echo -e "${BO}[INFO]${NC} ${log_message}"
  fi
}

declare -r _b_youtube_dl='/usr/local/bin/youtube-dl'
if [[ ! -f "${_b_youtube_dl}" ]] ; then
  log error  "${_b_youtube_dl} is not installed on the system. Exiting."
  exit 1
fi

_logdir='/var/log/yt'
if [[ ! -d "${_logdir}" ]] ; then
  log error "Log directory ${_logdir} does not exist. Exiting."
  exit 1
fi

_logfile="${_logdir}/download.log"
if ! touch "${_logfile}" &> /dev/null ; then
  log error "Log file ${_logfile} is not writable by user $(whoami). Exiting."
  exit 1
fi

_log_timestamp="$(date +'[%y/%m/%d %H:%M:%S]')"

_destination_folder='/srv/yt/downloads'
_video_url="${1}"

if [[ ! -d "${_destination_folder}" ]] ; then
  log error "Destination folder ${_destination_folder} does not exist. Please create it."
  exit 1
fi

_video_title="$(${_b_youtube_dl} -e "${_video_url}")"
_video_folder="${_destination_folder}/${_video_title}"

if [[ -d "${_video_folder}" ]] ; then
  log warn "Destination folder for this video already exists. Path : ${_video_folder}."
else
  mkdir "${_video_folder}" &> /dev/null
fi

_video_filename="$(${_b_youtube_dl} -o "%(title)s.%(ext)s" --get-filename "${_video_url}")"
_video_path="${_video_folder}/${_video_filename}"

if ! "${_b_youtube_dl}" "${_video_url}" \
  -o "${_video_path}" \
  --write-description \
  &> /dev/null
then
  log error "Can't download file. Exiting."
  exit 1
fi

mv "${_video_folder}/${_video_title}.description" "${_video_folder}/description"

log ok "Video ${_video_url} was downloaded."
log info "File path : ${_video_path}"

echo "${_log_timestamp} Video ${_video_url} was downloaded. File path : ${_video_path}" \
  >> "${_logfile}"
