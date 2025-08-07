# Inception

Create .env file in your srcs file.
For example, the contents are below.

```.env
# Mariadb
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=passpass
MYSQL_DATABASE=superpass

# Wordpress
WP_ADMIN_USER=tnakajo42
WP_ADMIN_PASSWORD=takoyaki
WP_ADMIN_EMAIL=example@gmail.com

# Editor
WP_EDITOR_USER=editor
WP_EDITOR_PASS=editorpass
WP_EDITOR_EMAIL=editor@gmail.com

WP_SITE_URL=https://tnakajo42.42.fr
WP_SITE_TITLE=SuperInceptionPage

# General
DOMAIN_NAME=tnakajo42.42.fr
```

# How do you work?

Just type:

```
$ make up
$ make ps
```

Then, open the link.
For example: https://tnakajo42.42.fr

If you change your program, type:

```
$ make down
```

If you want to delete the Wordpress and everything, type:

```
$ make fclean
```
