build:
	docker build -t music .

# make-audio:
# 	ffmpeg -f alsa -channels 1 -i hw:3 -t 15 -vn -acodec pcm_s16le 1.wav
# vosk-transcriber -i ./audio/1.wav -o 1.txt -m ./model

run:
	docker run \
		-p 7860:7860 \
		--privileged \
		--gpus all \
		--net=host \
		--restart=always \
		-e HF_ENDPOINT=http://dev.amberra.ru:8090 \
		music:latest

restart:
	docker stop $$(docker ps -a -q)
	make docker-build 
	make docker-run

stop-all:
	docker stop $$(docker ps -a -q)

copy-image:
	scp -r -i ~/amberra dmakeev@dev.amberra.ru:/opt/i1.tar /opt/ace/i1.tar