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

_b_youtube_dl="$(which youtube-dl)"
if [[ -z "${_b_youtube_dl}" ]] ; then
  log error  "youtube-dl is not accessible in $PATH. Exiting."
  exit 1
fi

_logdir='/var/log/yt'
if [[ ! -d "${_logdir}" ]] ; then
  log error "Log directory ${_logdir} does not exist. Exiting."
  exit 1
fi

_logfile="${_logdir}/download.log"
if ! touch "${_logfile}" ; then
  log error "Log file ${_logfile} is not writable by user $(whoami). Exiting."
  exit 1
fi

_log_timestamp="$(date +'[%y/%m/%d %H:%M:%S]')"

_destination_folder='./downloads'
  if [[ ! -d "${_destination_folder}" ]] ; then
    log error "Destination folder ${_destination_folder} does not exist. Please create it."
    exit 1
  fi
  
_video_list_file='./videos_list'
if [[ ! -f "${_video_list_file}" ]] ; then
  log error "File ${_video_list_file} does not exist. It should exist and contain one Youtube video URL per line. Exiting"
  exit 1
fi

_interval=1

while :
do

  # get the first line of URL file
  _video_url="$(head -n1 ${_video_list_file})"

  # if URL file is empty
  if [[ ! -s "${_video_list_file}" ]] ; then
    log info "File ${_video_list_file} is empty. Waiting ${_interval} seconds."
    sleep ${_interval}
    continue
  fi

  # if the line does not contain a well-formatted youtube video URL
  if [[ ! "${_video_url}" =~ ^https://www.youtube.com/watch\?v=[A-Za-z0-9_-]{11}$ ]] || [[ "${_video_url}" =~ ^https://youtu.be/[A-Za-z0-9_-]{11}$ ]] ; then
    log error "${_video_url} is not a valid Youtube URL. Deleting."
    sed -i '1d' "${_video_list_file}"
    log info "Remove ${_video_url} from ${_video_list_file}."
    sleep 1
    continue
  else
    log info "Found the following URL : ${_video_url}. Trying to download video."
  fi

  _video_title="$(${_b_youtube_dl} -e "${_video_url}")"
  _video_folder="${_destination_folder}/${_video_title}"
  
  if [[ -d "${_video_folder}" ]] ; then
    log warn "Destination folder for this video already exists. Path : ${_video_folder}. Using existing directory."
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

  sed -i '1d' "${_video_list_file}"
  log info "Remove ${_video_url} from ${_video_list_file}."

done
