# Workbench

Workbench is a quick and simple local web server for prototyping web applications and sites.

## Install

The first step is to install the gem:

	gem install work-bench

Workbench come with command line utility `workbench`.

## Create first project

Next we need create project.

	mkdir project
	cd project
	workbench init

## Start server

Inside project directory run:

	workbench start

## Export prototype

You can export your work using:

	workbench export

By default the project will export to a folder `export`.

## Help

Type `workbench` for more help and options.

## Additional features

You can specify the JS libraries to be used in your project.

	workbench init --js jquery json

The list of libraries available:

	workbench js --list

For add JS libraries to existing project in project dir type:

	workbench js --js json
