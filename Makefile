posts := $(patsubst %.md,%.html,$(wildcard app/blog/*.md)) 
VENV = .venv
PIP = $(VENV)/bin/pip
CONCORDE = $(VENV)/bin/concorde

.PHONY : all clean serve build html

all: build

deploy: html
	rsync -vcr --exclude=.DS_Store --exclude=.git* --exclude=*.sw* app/ dancraig.net:~/public_html/dancraig.net/public/

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

app/index.html: $(posts) templates/index.html $(CONCORDE)
	$(CONCORDE) index --template=templates/index.html --output=$@ app/blog/

app/blog/index.html : $(posts) templates/blog-index.html $(CONCORDE)
	$(CONCORDE) index --template=templates/blog-index.html --output=$@ app/blog/

app/blog/rss.xml : $(posts) $(CONCORDE)
	$(CONCORDE) rss --output=$@ --title="Dan Craig's Blog" --url="http://dancraig.net/blog/rss.xml" app/blog/

$(posts): app/blog/*.md templates/blog-post.html $(CONCORDE)
	$(CONCORDE) pages --template=templates/blog-post.html app/blog/

templates/index.html: templates/base.html
templates/blog-post.html: templates/base.html

$(CONCORDE): $(PIP)
	$(PIP) install concorde

$(PIP):
	virtualenv $(VENV)
