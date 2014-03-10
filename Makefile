posts := $(patsubst %.md,%.html,$(wildcard site/blog/*.md)) 

.PHONY : all clean serve

all: site/index.html site/blog/index.html site/blog/rss.xml $(posts)

serve:
	cd site && python -m SimpleHTTPServer

clean:
	-rm site/index.html
	-rm site/blog/index.html
	-rm site/blog/rss.xml
	-rm $(posts)

site/index.html: $(posts) templates/index.html
	concorde index --template=templates/index.html --output=$@ --output-extension=.html site/blog/

site/blog/index.html : $(posts) templates/blog-index.html
	concorde index --template=templates/blog-index.html --output=$@ --output-extension=.html site/blog/

site/blog/rss.xml : $(posts)
	concorde rss --output=$@ --title="Dan Craig's Blog" --url="http://dancraig.net/blog/rss.xml" site/blog/

$(posts): site/blog/*.md templates/blog-post.html
	concorde pages --template=templates/blog-post.html site/blog/
