posts := $(patsubst %.md,%.html,$(wildcard app/blog/*.md)) 

.PHONY : all clean serve

all: app/index.html app/blog/index.html app/blog/rss.xml $(posts)

serve:
	cd app && python -m SimpleHTTPServer

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
