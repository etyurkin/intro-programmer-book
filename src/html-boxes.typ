#let css-paint(p) = {
  if type(p) == color { p.to-hex() } else { none }
}

#let css-px(value) = {
  if type(value) == relative { str(value.length.pt()) + "px" }
  else if type(value) == length { str(value.pt()) + "px" }
  else { none }
}

#let stroke-css(st) = {
  if st == none { "" }
  else if type(st) == stroke {
    let paint = css-paint(st.paint)
    if paint == none { "" }
    else { "border:" + str(st.thickness.pt()) + "px solid " + paint + ";" }
  } else if type(st) == dictionary {
    let s = ""
    for (side, val) in st {
      let paint = css-paint(val.paint)
      if paint != none {
        s += "border-" + side + ":" + str(val.thickness.pt()) + "px solid " + paint + ";"
      }
    }
    s
  } else { "" }
}

#let inset-css(ins) = {
  let px = css-px(ins)
  if px != none { "padding:" + px + ";" }
  else if type(ins) == dictionary {
    let s = ""
    for (side, val) in ins {
      let p = css-px(val)
      if p != none { s += "padding-" + side + ":" + p + ";" }
    }
    s
  } else { "" }
}

#let radius-css(r) = {
  let px = css-px(r)
  if px != none { "border-radius:" + px + ";" } else { "" }
}

#let html-colored-block(it) = context {
  if target() != "html" { it }
  else {
    let fill = css-paint(it.fill)
    let border = stroke-css(it.stroke)
    if fill == none and border == "" { it }
    else {
      let css = "margin:0.8em 0;"
      if fill != none { css += "background:" + fill + ";" }
      css += border
      css += inset-css(it.inset)
      css += radius-css(it.radius)
      html.elem("div", attrs: (style: css), it.body)
    }
  }
}

#let html-colored-box(it) = context {
  if target() != "html" { it }
  else if it.fill == none { it }
  else {
    let fill = css-paint(it.fill)
    let css = ""
    if fill != none { css += "background:" + fill + ";" }
    css += inset-css(it.inset)
    css += radius-css(it.radius)
    html.elem("span", attrs: (style: css), it.body)
  }
}

#let html-ink(fill, body, weight: auto, size: auto) = context {
  if target() != "html" {
    set text(fill: fill)
    if weight != auto { set text(weight: weight) }
    if size != auto { set text(size: size) }
    body
  } else {
    let css = "color:" + fill.to-hex() + ";"
    if weight == "bold" { css += "font-weight:bold;" }
    if size != auto { css += "font-size:" + str(size.pt()) + "pt;" }
    html.elem("span", attrs: (style: css), body)
  }
}
