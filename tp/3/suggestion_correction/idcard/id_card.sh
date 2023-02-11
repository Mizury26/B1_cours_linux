#!/bin/bash
# lil id card script
# it4 28/11/2022

declare -r _hostname="$(hostnamectl --static)"
echo "Machine name : ${_hostname}"

source /etc/os-release
declare -r _os_name="${NAME}"
declare -r _kernel="$(uname -r)"
echo "OS ${_os_name} and kernel version is ${_kernel}"

declare -r _ip="$(ip a | grep 'inet ' | tail -n1 | tr -s ' ' | cut -d' ' -f3)"
echo "IP : ${_ip}"

declare -r _total_memory="$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f2)"
declare -r _available_memory="$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7)"
echo "RAM : ${_available_memory} memory available on ${_total_memory} total memory"


declare -r _free_disk_space="$(df -h | grep ' /$' | tr -s ' ' | cut -d' ' -f4)"
echo "Disk : ${_free_disk_space} space left"

declare -r _top5_processes="$(ps -e -o command= --sort=-%mem | head -n 5)"
echo 'Top 5 processes by RAM usage :'
while read line
do
  _process_name=$(cut -d' ' -f1 <<< "${line}")
  echo "  - ${_process_name}"
done <<< "${_top5_processes}"


echo 'Listening ports :'
declare -r _listening_tcp_programs="$(ss -lnp4tH | tr -s ' ')"
if [[ ! -z $_listening_tcp_programs ]] ; then
  while read line
  do
    _tcp_port="$(cut -d' ' -f4 <<< "${line}" | cut -d':' -f2)"
    _tcp_program="$(cut -d' ' -f6 <<< \"${line}\" | cut -d'"' -f2)"
    echo "  - ${_tcp_port} tcp : ${_tcp_program}"
  done <<< "${_listening_tcp_programs}"
fi

declare -r _listening_udp_programs="$(ss -lnp4uH | tr -s ' ')"
if [[ ! -z $_listening_udp_programs ]] ; then
  while read line
  do
    _udp_port="$(cut -d' ' -f4 <<< "${line}" | cut -d':' -f2)"
    _udp_program="$(cut -d' ' -f6 <<< \"${line}\" | cut -d'"' -f2)"
    echo "  - ${_udp_port} udp : ${_udp_program}"
  done <<< "${_listening_udp_programs}"
fi

# Cat picture
_cat_filename='cat_pic'
curl https://cataas.com/cat -o "${_cat_filename}" 2> /dev/null
_file_command_output="$(file cat_pic)"

if [[ "${_file_command_output}" == *JPEG* ]]
then
  _cat_file_extension='.jpeg'
elif [[ "${_file_command_output}" == *PNG* ]]
then
  _cat_file_extension='.png'
elif [[ "${_file_command_output}" == *GIF* ]]
then
  _cat_file_extension='.gif'
else
  echo "Don't know this format :( Exiting."
  exit 1
fi
_cat_new_filename="${_cat_filename}${_cat_file_extension}"
mv "${_cat_filename}" "${_cat_new_filename}"
echo "Here is your random cat : ${_cat_new_filename}"
