# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Static marketing website for Cohesive Technology Ltd (cohesivetechnology.co.uk). Four hand-written HTML pages (`index.html`, `about.html`, `services.html`, `contact.html`) sharing `styles.css` and `index.js`. No build step, no package manager, no tests — files are deployed as-is.

## Local preview

There is no dev server config. To view changes, open the HTML file directly in a browser, or run a throwaway static server from the repo root:

```
python3 -m http.server 8000
```

## Deploy

`./deploy.sh` syncs the repo to S3 and invalidates CloudFront. It's a thin wrapper around `aws s3 sync` + `aws cloudfront create-invalidation` — read it before running.

Defaults at the top of `deploy.sh`:
- `S3_BUCKET=cohesivetechnology.co.uk`
- `AWS_REGION=eu-west-2`
- `CLOUDFRONT_DISTRIBUTION_ID=EDBWZ35WCVZFC`

Override any value via env var: `S3_BUCKET=foo CLOUDFRONT_DISTRIBUTION_ID=ETO... ./deploy.sh`. The script excludes `.git/`, `CLAUDE.md`, `deploy.sh` itself, `.gitignore`, and `*.md` from the upload. The S3 bucket, CloudFront distribution, ACM cert (must be in us-east-1), and DNS are managed outside the repo.

Note: the sister properties `technologyadvisoryboard.net` and `technologyduediligence.net` are on **Cloudflare Pages** with a Python/Jinja2/Tailwind build. Cohesive deliberately uses a different stack (S3 + CloudFront, plain HTML, no build) — do not assume the deploy mechanisms are interchangeable.

## Architecture and conventions

- **Bootstrap 5.3 + Font Awesome 6.4 + jQuery 3.7** are all loaded from CDNs in every page. There is no local copy or version pinning beyond the `<link>`/`<script>` URLs — bump them in all four HTML files together.
- **`styles.css` is the live stylesheet.** `site.css` is a legacy file from an older version of the site and is not referenced by any current page — don't add rules to it.
- **Brand color is `--brand-green: #008701`**, defined as a CSS variable at the top of `styles.css`. Use the variable, not the literal hex.
- **The navbar logo is an inline SVG data URI** (the green node-graph icon) duplicated in the `<a class="navbar-brand">` of every page. When changing the logo, update all four pages.
- **Navigation, footer, and Google Analytics snippet (UA-115935846-1) are duplicated across pages.** Any change to nav links, footer content, or analytics must be applied to all four HTML files. There is no templating.
- **`index.js` is loaded by every page** and handles smooth-scroll for `#` anchors, active-nav-link highlighting based on `window.location.pathname`, and a scroll-triggered opacity fade for `.service-card`.
- **`outwith/` holds icon assets for a separate "Outwith" sub-brand**, not used by the main site pages — leave it alone unless explicitly asked.
- **`BingSiteAuth.xml`** is a site-ownership verification file for Bing — do not rename or delete.
- **`favicon.svg`** is the navbar node-graph icon extracted to a standalone file. The same SVG is also inlined as a data-URI in the navbar of each HTML page — if you change one, change both.

## SEO / LLM-discoverability files

These site-root files exist for search engines and LLM crawlers — keep them in sync with site content.

- **`robots.txt`** — allows all crawlers including named AI bots (GPTBot, ClaudeBot, Google-Extended, PerplexityBot, etc.) and points to the sitemap.
- **`sitemap.xml`** — lists the four HTML pages with `lastmod` dates. Bump `lastmod` when content materially changes.
- **`llms.txt`** — concise structured summary for LLMs per the llmstxt.org convention. Lists pages with one-line descriptions and links to the two co-sponsored guides.
- **`llms-full.txt`** — full markdown rendering of the site content (single file, all four pages). Keep in sync with the HTML when page content changes meaningfully.
- **JSON-LD structured data** — embedded in each page's `<head>`. `ProfessionalService` schema on every page; `Person` schema for Rory on about.html; `ItemList` of `Service` entries on services.html.

## Cross-property references

The site links out to two sibling properties that Cohesive Technology co-sponsors:

- `https://technologyduediligence.net` — referenced in the services.html TDD section and in the footer "Independent guides" column.
- `https://technologyadvisoryboard.net` — referenced in the services.html Advisory section and in the footer "Independent guides" column.

These references are deliberate positioning, not ad-hoc links. Both sister sites list Cohesive Technology and ReThought Solutions as named sponsors. **Do not promote either site as a Cohesive product** — they are editorially independent guides; the value of the cross-reference depends on preserving that independence. Use the **root domain** form (no `www.` prefix) when linking, and prefer parallel wording for the two guides so the pairing is legible.

The hero on `index.html` and the services.html anchors (`#for-investors`, `#for-founders`) implement a two-door audience pattern — investors / founders. Keep that split visible if reorganising the homepage.
