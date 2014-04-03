posts := $(patsubst %.md,%.html,$(wildcard app/blog/*.md)) 

.PHONY : all clean serve build html

all: build

deploy: build
	rsync -vcr --exclude=.DS_Store --exclude=.git* --exclude=*.sw* app/ cilantro:~/public_html/dancraig.net/public/
	ssh -t cilantro sudo "/etc/init.d/apache2 reload"

serve: html
	./grunt-dev.command

build: html
	./grunt-build.command

html: app/index.html app/blog/index.html app/blog/rss.xml $(posts)

clean:
	-rm app/index.html
	-rm app/blog/index.html
	-rm app/blog/rss.xml
	-rm $(posts)

app/index.html: $(posts) templates/index.html
	concorde index --template=templates/index.html --output=$@ app/blog/

app/blog/index.html : $(posts) templates/blog-index.html
	concorde index --template=templates/blog-index.html --output=$@ app/blog/

app/blog/rss.xml : $(posts)
	concorde rss --output=$@ --title="Dan Craig's Blog" --url="http://dancraig.net/blog/rss.xml" app/blog/

$(posts): app/blog/*.md templates/blog-post.html
	concorde pages --template=templates/blog-post.html app/blog/

templates/index.html: templates/base.html
templates/blog-post.html: templates/base.html
