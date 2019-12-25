all: bundle

serve:
	python3 -m http.server --bind 127.0.0.1 34348

bundle: dist/index.html dist/b64lzma.js dist/main.js dist/elm.js dist/lzma/lzma-d-min.js dist/lzma/lzma_worker-min.js
	python3 bundle.py dist/index.html

dist/lzma/%: lib/lzma/%
	mkdir -p dist/lzma
	cp "$<" "$@"

dist/index.html: src/index.html
	mkdir -p dist
	cp "$<" "$@"

dist/main.js: src/main.js
	mkdir -p dist
	cp "$<" "$@"

dist/b64lzma.js: src/b64lzma.js
	mkdir -p dist
	cp "$<" "$@"

dist/elm.js: src/*.elm src/*/*.elm
	elm make src/Main.elm --output="$@"
