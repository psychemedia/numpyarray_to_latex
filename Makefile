PKG=numpyarray_to_latex
PYTHON=python3
PIP=pip3

default: 
	make ${PYTHON}

clean:
	-rm -f *.o
	make pyclean

clean_all:
	make clean
	make pyclean

pyclean:
	-rm -f *.so
	-rm -rf *.egg-info*
	-rm -rf ./tmp/
	-rm -rf ./build/

python:
	${PIP} install -e .

checkdocs:
	${PYTHON} setup.py checkdocs

pypi:
	mkdir -p dist
	touch dist/foobar
	rm dist/*
	${PYTHON} setup.py sdist
	twine check dist/*

upload:
	twine upload dist/*

readme:
	pandoc --from markdown_github --to rst README.md > _README.rst
	sed -e "s/^\:\:/\.\. code\:\: bash/g" _README.rst > __README.rst
	sed -e "s/\.\. code\:\: math/\.\. code\:\:/g" __README.rst > README.rst
	rm _README.rst
	rm __README.rst
	rstcheck README.rst
	cd docs; ${PYTHON} make_about.py

test:
	pytest --cov=${PKG} ${PKG}/tests/

authors:
	${PYTHON} authorlist.py

grootinstall:
	/opt/${PYTHON}36/bin/pip3.6 install --user ../${PKG}

groot:
	git fetch
	git pull
	make grootinstall
