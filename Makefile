# encoding=utf-8

all:

clean:
	rm -rf tmp/ .vim/ .tmux/ .local/

static:
	git submodule update --init
	curl https://www.fial.com/~scott/tamsyn-font/download/tamsyn-font-1.11.tar.gz --output tmp/tamsyn-font-1.11.tar.gz
	tar xvf tmp/tamsyn-font-1.11.tar.gz -C .local/share/

npull:
	rsync -viar $$HOME/ ./ --include-from=./rsyncinclude --exclude="*" -n

npush:
	rsync -viar ./ $$HOME/ --include-from=./rsyncinclude --exclude="*" -n

pull:
	rsync -viar $$HOME/ ./ --include-from=./rsyncinclude --exclude="*"

push:
	rsync -viar ./ $$HOME/ --include-from=./rsyncinclude --exclude="*"
