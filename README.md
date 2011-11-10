# Workbench

Workbench is a quick and simple local web server for prototyping web applications and sites. It supports HAML, SASS and Compass out of the box.

## Install

The first step is to install the gem:

	gem install work-bench

Workbench comes with command line utility `workbench`.

## Create first project

Next we need to create project.

	mkdir project
	cd project
	workbench init

## Start server

Inside project directory run:

	workbench start

Now type in browser `http://localhost:4000`. And you will see the start page.

## Export prototype

You can export your work using:

	workbench export

By default the project will export to a folder `export`.

## Help

Type `workbench` for more help and options.

## Additional features

You can specify the JS libraries to be used in your project.

	workbench init --js jquery json

List of libraries available:

	workbench js

## normalize.css

You can add awesome [normalize.css](https://github.com/jonathantneal/normalize.css) to project. Just use `--normalize` or `--no-normalize` in options. This feature is **enabled** by default.

	workbench init --normalize

