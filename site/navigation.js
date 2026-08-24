(() => {
  const nav = document.querySelector(".nav");
  const brand = nav?.querySelector(".brand");
  const hasInnerHero = Boolean(document.querySelector(".hero")) && !document.querySelector("#top");
  const isAbout = Boolean(document.querySelector(".masthead"));

  const pageByLabel = {
    首页: "home",
    公益科普: "science",
    典型案例: "cases",
    数据监测: "dashboard",
    价值实现: "value",
    生态故事: "stories",
    公益故事: "stories",
    公众参与: "community",
    倡议留言: "community",
    关于本站: "about",
  };
  const activeLabel = nav?.querySelector(".nav-links a.active")?.textContent?.replace(/\s+/g, "").trim();
  const pageId = document.body.dataset.sitePage || pageByLabel[activeLabel] || (isAbout ? "about" : document.querySelector("#top") ? "home" : "");

  const pageMeta = {
    home: { label: "首页", href: "/site/index.html", summary: "返回网站首页，快速了解栏目与治理成果", icon: "<path d='M3.5 10.7 12 3.8l8.5 6.9'/><path d='M5.5 9.6v10.1h13V9.6M9.3 19.7v-6.2h5.4v6.2'/>" },
    science: { label: "公益科普", href: "/site/science/index.html", summary: "认识石漠化的成因、分级、危害与修复方式", icon: "<path d='M12 6.3v13m0-13C10.8 5.5 9.2 5 7.5 5S4.2 5.5 3 6.3v13c1.2-.8 2.8-1.3 4.5-1.3s3.3.5 4.5 1.3m0-13C13.2 5.5 14.8 5 16.5 5S19.8 5.5 21 6.3v13c-1.2-.8-2.8-1.3-4.5-1.3s-3.3.5-4.5 1.3'/>" },
    cases: { label: "典型案例", href: "/site/cases/index.html", summary: "走进川滇黔代表地区，看见治理实践与变化", icon: "<path d='M3 21v-4V5a2 2 0 0 1 2-2h6.5l1 1H21l-3 6 3 6h-8.5l-1-1H5a2 2 0 0 0-2 2Zm9-13.5V9'/>" },
    dashboard: { label: "数据监测", href: "/site/dashboard/index.html", summary: "用公开调查数据观察石漠化面积与生态趋势", icon: "<path d='M5 20v-7h4v7H5Zm6 0V8h4v12h-4Zm6 0V4h4v16h-4Z'/><path d='M3 20h19'/>" },
    value: { label: "价值实现", href: "/site/value/index.html", summary: "了解生态修复如何转化为可持续的发展价值", icon: "<path d='M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z'/><path d='M12 7v10m3-8.3c-.7-1-1.7-1.5-3-1.5-1.7 0-3 .9-3 2s1.3 2 3 2 3 .9 3 2-1.3 2-3 2c-1.3 0-2.3-.5-3-1.5'/>" },
    stories: { label: "生态故事", href: "/site/stories/index.html", summary: "阅读来自真实报道的治理人物、村庄与行动", icon: "<path d='M5 4h14a2 2 0 0 1 2 2v13H7a3 3 0 0 0-3 3V5a1 1 0 0 1 1-1Z'/><path d='M7 19h14M8 8h8m-8 4h6'/>" },
    community: { label: "公众参与", href: "/site/community/index.html", summary: "写下你的生态寄语，让新的声音加入留言流动", icon: "<path d='M21 12a8 8 0 0 1-8 8H5l-3 2 1.2-4.4A8.5 8.5 0 1 1 21 12Z'/><path d='M8 12h.01M12 12h.01M16 12h.01'/>" },
    about: { label: "关于本站", href: "/site/about/index.html", summary: "了解建站初衷、内容依据与使用声明", icon: "<circle cx='12' cy='12' r='9'/><path d='M12 11v6m0-10h.01'/>" },
  };
  const pageOrder = ["home", "science", "cases", "dashboard", "value", "stories", "community", "about"];
  if (hasInnerHero) document.body.classList.add("site-inner-hero");
  if (isAbout) document.body.classList.add("site-about");
  if (pageId) document.body.dataset.sitePage = pageId;

  if (hasInnerHero) {
    const hero = document.querySelector(".hero");
    let scrollCue = hero?.querySelector(":scope > .scroll-cue, :scope > .scroll-note");
    if (!scrollCue && hero) {
      scrollCue = document.createElement("div");
      hero.appendChild(scrollCue);
    }
    if (scrollCue) {
      scrollCue.classList.add("site-hero-scroll");
      scrollCue.setAttribute("aria-hidden", "true");
      scrollCue.textContent = "";
    }
  }

  if (brand && !brand.querySelector(".brand-mark,.brand-icon")) {
    const mark = document.createElement("span");
    mark.className = "brand-mark site-brand-mark";
    mark.setAttribute("aria-hidden", "true");
    mark.innerHTML = '<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M12 22V8m0 0C8.5 8 6 6 5 3c3.6-.2 6.1 1.1 7 5Zm0 4c3.5 0 6-2 7-5-3.6-.2-6.1 1.1-7 5Z"/></svg>';
    brand.prepend(mark);
  }

  const footer = document.querySelector("footer");
  if (footer && pageId) {
    footer.className = "site-footer";
    footer.innerHTML = `<div class="site-footer-wrap"><div class="site-footer-grid"><div class="site-footer-intro"><div class="site-footer-brand"><span><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M3.1 11H5a2 2 0 0 1 2 2v1a2 2 0 0 0 2 2 2 2 0 0 1 2 2v3M8 4v1.5A2.5 2.5 0 0 0 10.5 8h.5a2 2 0 1 1 4 0 2 2 0 0 0 2-2h2M15 20v-2a2 2 0 0 1 2-2h3M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg></span><strong>石漠化治理公益科普</strong></div><p>本站是一个纯公益性质的科普平台，致力于传播石漠化治理知识，展示生态修复成果，探讨生态产品价值实现路径。</p></div><nav class="site-footer-links" aria-label="底部快速链接"><h3>快速链接</h3><ul>${pageOrder
      .map((id) => `<li><a href="${pageMeta[id].href}"${id === pageId ? ' aria-current="page"' : ""}>${pageMeta[id].label}</a></li>`)
      .join("")}</ul></nav><div class="site-footer-statement"><h3>公益声明</h3><p>本站不涉及任何商业行为。所有内容仅供公益科普与学习交流，数据和文章参考相关政府部门、公开科研报告及权威媒体报道。</p></div></div><div class="site-footer-copy">© 2026 石漠化治理公益科普项目. 保留所有权利.</div></div>`;
  }
  if (footer && pageId && pageId !== "home") {
    document.querySelectorAll(".next").forEach((node) => node.classList.add("site-original-next"));
    const nextIndex = pageOrder.indexOf(pageId) + 1;
    const nextId = nextIndex < pageOrder.length ? pageOrder[nextIndex] : "home";
    const nextBlock = document.createElement("section");
    nextBlock.className = "site-next-page";
    nextBlock.innerHTML = `<div class="site-system-wrap"><span>${pageId === "about" ? "继续浏览" : "下一页"}</span><a href="${pageMeta[nextId].href}">${pageMeta[nextId].label}<i>→</i></a></div>`;

    footer.before(nextBlock);
  }



  document.querySelectorAll("a[href]").forEach((link) => {
    const rawHref = link.getAttribute("href");
    if (!rawHref || rawHref.startsWith("#")) return;
    const isInternal =
      !/^https?:/i.test(rawHref) &&
      (Boolean(link.closest("nav")) ||
        link.classList.contains("brand") ||
        rawHref.startsWith("./") ||
        rawHref.startsWith("../") ||
        rawHref.startsWith("/site/"));
    if (!isInternal) return;
    link.setAttribute("target", "_self");
    link.addEventListener("pointerdown", () => {
      link.classList.add("site-nav-clicked");
      window.setTimeout(() => link.classList.remove("site-nav-clicked"), 180);
    });
  });
})();
