---
layout: default
title: 列表
permalink: /list.html
---

<div class="home">

  <h2 class="page-heading">文章</h2>

  <ul class="post-list">
    {% for post in site.posts %}
      <li>
        

        <h3>
          <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>&nbsp;&#45;&nbsp;<small><span class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</span></small>
        </h3>
      </li>
    {% endfor %}
  </ul>
</div>
