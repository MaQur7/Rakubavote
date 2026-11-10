#!/usr/bin/env python3
"""Writes the Rakubavote logo files (brand/) from one set of numbers.

The mark is built on a unit u = 4 in a 120 x 120 square (D26):
  roof  26u x 4u, corner radius 1u
  posts 3u x 16u, 3u in from each roof end (the overhang)
  bay   14u x 16u between the posts
  tick  45 degrees, arms 1 : 2, stroke 3u with round ends, centred in the bay

Run: python3 tool/brand_assets.py   (PNG files need Pillow)
"""
import os

NILE, THATCH, LTHATCH, INK, PAPER, WHITE = '#1D4E89', '#C8963E', '#E6C27A', '#1B1B1B', '#F4F1EA', '#FFFFFF'

ROOF = dict(x=8, y=20, w=104, h=16, r=4)
POSTS = [dict(x=20, y=36, w=12, h=64), dict(x=88, y=36, w=12, h=64)]
TICK = [(42, 72), (54, 84), (78, 60)]
TICK_W = 12


def mark(roof, post, tick):
    """The mark as SVG shapes in a 0 0 120 120 box."""
    d = 'M%d %d L%d %d L%d %d' % (TICK[0] + TICK[1] + TICK[2])
    out = '<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{c}"/>'.format(c=roof, **ROOF)
    for p in POSTS:
        out += '<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{c}"/>'.format(c=post, **p)
    out += ('<path d="%s" fill="none" stroke="%s" stroke-width="%d" stroke-linecap="round" '
            'stroke-linejoin="round"/>' % (d, tick, TICK_W))
    return out


SCHEMES = {
    'colour': (THATCH, INK, NILE, INK, NILE),
    'on-dark': (LTHATCH, PAPER, PAPER, PAPER, LTHATCH),
    'one-colour': (INK, INK, INK, INK, INK),
}


def svg_mark(scheme, title='Rakubavote mark'):
    roof, post, tick, _, _ = SCHEMES[scheme]
    return ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120" role="img" aria-label="%s">%s</svg>\n'
            % (title, mark(roof, post, tick)))


def svg_lockup(scheme):
    """Mark and wordmark. The wordmark is Atkinson Hyperlegible Bold (assets/fonts)."""
    roof, post, tick, w1, w2 = SCHEMES[scheme]
    return ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 520 120" role="img" aria-label="Rakubavote">'
            '%s<text x="140" y="84" font-family="\'Atkinson Hyperlegible\', AtkinsonHyperlegible, sans-serif" '
            'font-weight="700" font-size="68" letter-spacing="-0.7" fill="%s">Rakuba<tspan fill="%s">vote</tspan></text>'
            '</svg>\n' % (mark(roof, post, tick), w1, w2))


def svg_app_icon():
    return ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160" role="img" aria-label="Rakubavote app icon">'
            '<rect width="160" height="160" rx="35" fill="%s"/><g transform="translate(20 20)">%s</g></svg>\n'
            % (NILE, mark(LTHATCH, PAPER, PAPER)))


def png_mark(path, size, roof, post, tick, bg=None, radius=0, inset=0.0):
    from PIL import Image, ImageDraw
    s = 8  # supersample
    big = size * s
    img = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    if bg:
        d.rounded_rectangle([0, 0, big - 1, big - 1], radius=int(radius * big), fill=bg)
    k = big * (1 - 2 * inset) / 120.0
    o = big * inset

    def X(v):
        return o + v * k

    d.rounded_rectangle([X(ROOF['x']), X(ROOF['y']), X(ROOF['x'] + ROOF['w']), X(ROOF['y'] + ROOF['h'])],
                        radius=ROOF['r'] * k, fill=roof)
    for p in POSTS:
        d.rectangle([X(p['x']), X(p['y']), X(p['x'] + p['w']), X(p['y'] + p['h'])], fill=post)
    pts = [(X(x), X(y)) for x, y in TICK]
    d.line(pts, fill=tick, width=int(round(TICK_W * k)), joint='curve')
    r = TICK_W * k / 2
    for x, y in pts:
        d.ellipse([x - r, y - r, x + r, y + r], fill=tick)
    img.resize((size, size), Image.LANCZOS).save(path)


def png_lockup(path, scheme, bg, height=240):
    from PIL import Image, ImageDraw, ImageFont
    roof, post, tick, w1, w2 = SCHEMES[scheme]
    k = height / 120.0
    font = ImageFont.truetype('assets/fonts/AtkinsonHyperlegible-Bold.ttf', int(68 * k))
    tmp = '/tmp/_rkv_mark.png'
    png_mark(tmp, height, roof, post, tick)
    m = Image.open(tmp)
    w_a = font.getlength('Rakuba')
    w_b = font.getlength('vote')
    pad = int(20 * k)
    img = Image.new('RGBA', (int(140 * k + w_a + w_b) + pad * 2, height + pad * 2), bg)
    img.alpha_composite(m, (pad, pad))
    d = ImageDraw.Draw(img)
    base = pad + int(84 * k)
    d.text((pad + 140 * k, base), 'Rakuba', font=font, fill=w1, anchor='ls')
    d.text((pad + 140 * k + w_a, base), 'vote', font=font, fill=w2, anchor='ls')
    img.save(path)
    os.remove(tmp)


def main():
    os.makedirs('brand', exist_ok=True)
    files = {
        'brand/rakubavote-mark.svg': svg_mark('colour'),
        'brand/rakubavote-mark-on-dark.svg': svg_mark('on-dark'),
        'brand/rakubavote-mark-one-colour.svg': svg_mark('one-colour'),
        'brand/rakubavote-logo.svg': svg_lockup('colour'),
        'brand/rakubavote-logo-on-dark.svg': svg_lockup('on-dark'),
        'brand/rakubavote-logo-one-colour.svg': svg_lockup('one-colour'),
        'brand/rakubavote-app-icon.svg': svg_app_icon(),
    }
    for path, text in files.items():
        with open(path, 'w') as f:
            f.write(text)
    try:
        png_mark('brand/rakubavote-app-icon-512.png', 512, LTHATCH, PAPER, PAPER, bg=NILE, radius=0.22, inset=0.125)
        png_mark('brand/rakubavote-mark-512.png', 512, THATCH, INK, NILE)
        png_lockup('brand/rakubavote-logo.png', 'colour', PAPER)
        png_lockup('brand/rakubavote-logo-on-dark.png', 'on-dark', INK)
        png_lockup('brand/rakubavote-logo-one-colour.png', 'one-colour', WHITE)
    except ImportError:
        print('Pillow not installed: SVG files written, PNG files skipped')
    print('brand files written')


if __name__ == '__main__':
    main()
