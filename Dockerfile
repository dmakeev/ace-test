FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

ENV CHECK_UPDATE="false"
ENV HOST="0.0.0.0"
#ENV CONFIG_PATH="/home/app/model"
#ENV LM_MODEL_PATH="/home/app/llm"
ENV DOWNLOAD_SOURCE="modelscope"
ENV INIT_LLM="true"

WORKDIR /home/app

RUN apt update && \
  apt upgrade -y && \
  apt install -y git curl software-properties-common && \
  add-apt-repository ppa:deadsnakes/ppa && \
  apt install -y python3.11 python3-pip && \
  dpkg -l | awk "/^(ii|rc) +linux-(image|headers)-[0-9]/{print \$2}" | grep -vE "$( (dpkg -l | grep -oP "linux-(image|headers)-\K[\d.]+-\d+" | sort -uV | tail -2; uname -r | grep -oP "[\d.]+-\d+") | sort -u | paste -sd"|")" | xargs apt purge --autoremove -y && \
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* /var/tmp/* /var/cache/apk/*

RUN pip3 install uv --break-system-packages && \
  git clone https://github.com/ACE-Step/ACE-Step-1.5.git . && \
  uv sync && \
  chmod +x start_gradio_ui.sh start_api_server.sh

RUN mkdir /home/app/model && mkdir /home/app/llm

EXPOSE 8001
EXPOSE 7860

CMD uv run acestep --server-name "0.0.0.0" --init_llm true --download-source modelscope
#CMD ./start_gradio_ui.sh


#CMD ["python3" "-X" "dev" "./src/main.py"]
# CMD python3 -X dev ./src/main.py
# ENTRYPOINT ["tail", "-f", "/dev/null"]
# CMD fastapi dev --host 0.0.0.0 ./src/main.py
