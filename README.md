# ptichko.github.io

Personal website for Parker Tichko. Jekyll site built on the Start Bootstrap
"Clean Blog" theme.

## Local development

The site needs Ruby (Jekyll) and Node (the LESS/CSS build).

```sh
bundle install     # Jekyll + plugins
npm install        # grunt and its plugins
```

Serve it locally:

```sh
bundle exec jekyll serve
```

If Ruby is not installed, the build runs in Docker against the same gem set:

```sh
docker run --rm -v "${PWD}:/srv/jekyll" -v jekyll-bundle:/usr/local/bundle \
  jekyll/builder:latest bundle exec jekyll build
```

`Gemfile.lock` is gitignored, so the bundle has to be installed into the
volume once (`bundle install` inside the same `docker run` invocation) before
a build will succeed.

GitHub Pages builds the site itself on push, so no deploy step is needed.

## Rebuilding the CSS and JS

The theme's LESS source lives in `less/` and compiles to `css/clean-blog.css`
and `css/clean-blog.min.css`. Both are committed because GitHub Pages builds do
not run the asset pipeline.

```sh
npm run build      # uglify + less + banner, writes the committed assets
npm run watch      # rebuild on change
```

After editing anything in `less/`, run `npm run build` and commit the
regenerated `css/` files — otherwise the stylesheet served from GitHub Pages
will silently fall out of date.

## Layout of the repo

| Path | Purpose |
| --- | --- |
| `index.html` | Home page, lists posts with pagination |
| `1_about.md` … `5_blog.md` | Top-level pages. Nav order comes from `nav_order`, not the filename prefix. |
| `_posts/` | Blog posts, filename is the publish date |
| `_layouts/`, `_includes/` | Jekyll templates |
| `_config.yml` | Site settings and `plugins` list |
| `less/`, `css/` | Theme stylesheet source and its compiled output |
| `js/` | jQuery, Bootstrap, and the theme script (committed; Pages does not run Grunt) |
| `img/` | Photos and figures |
| `CV/` | PDF scores and curriculum vitae |
| `r/` | R scripts referenced by the tutorial posts |
| `olderpages/` | Archived pages. `nav: false` keeps them off the navbar. |

## Adding a page

Nav membership is explicit. A page appears in the navbar only if it sets
`nav: true`; `nav_order` sorts it (lower comes first). A page with no `nav`
key is still published and reachable, just unlinked — that is how
`olderpages/` works.

```yaml
---
layout: page
title: "Page Title"
description: "One sentence used for search results and link previews."
nav: true
nav_order: 6
header-img: "img/Banner.jpg"
---
```

`description` is not optional in practice: it falls back to `site.description`,
which means every page ships the same generic text to search engines and link
previews. Set `archived: true` alongside `nav: false` to get the banner that
marks an out-of-date page.

## Images

Every `<img>` needs `alt`, `width`, `height`, and `loading="lazy"`. The
dimensions are required, not optional: without them the browser cannot reserve
space and the page shifts as images decode.

```html
<figure class="text-center">
  <img src="/img/plot.png" alt="What the figure shows, not just what it is."
       width="600" height="298" loading="lazy" decoding="async">
  <figcaption>Optional caption.</figcaption>
</figure>
```

Use `<figure>`/`<figcaption>` rather than a bare `<div>`, and `.text-center`
rather than `<p align="center">` — a `<figcaption>` is not valid inside a `<p>`.

Animated figures should ship as WebP with a static poster fallback:

```html
<picture>
  <source srcset="/img/simulation.webp" type="image/webp">
  <img src="/img/simulation-poster.png" alt="..." width="380" height="651"
       loading="lazy" decoding="async">
</picture>
```

Keep `img/` small. It is the largest thing GitHub Pages serves, and a single
oversized file dominates the whole site. Before committing a new image,
resize it to roughly twice its largest on-screen display size and re-encode
(quality ~82 for photos, quantized to 256 colors for line art). A 12 MB GIF
became a 2 MB WebP this way.

Icon-only links need a text label for screen readers:

```html
<a href="/CV/score.pdf" target="_blank" rel="noopener">
  <i class="fa fa-file-text fa-md" aria-hidden="true"></i>
  <span class="visually-hidden">Download the score for Prelude No. 1</span>
</a>
```

`aria-hidden="true"` on the `<i>` stops the icon being announced twice.
`.visually-hidden` is defined in `less/clean-blog.less`.

## Theme dependencies

The theme is Start Bootstrap Clean Blog, which targets Bootstrap 3 and
Font Awesome 4. Both are past end of life, so a few things are pinned
deliberately:

- **Font Awesome stays on 4.x.** v5 removed `fa-stack`, `fa-inverse`, and the
  bare `fa fa-*` classes this theme uses throughout. Upgrading requires
  converting every icon call site first.
- **Bootstrap CSS and JS are both 3.4.1.** They must match.
- Google Fonts use the legacy `css?family=` API with explicit weight lists.
  Bumping to the CSS2 `wght@` syntax requires adding `ital` axes too.

Adding a new dependency means checking what the theme already assumes.