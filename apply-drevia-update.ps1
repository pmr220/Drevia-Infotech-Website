
# DREVIA INFOTECH WEBSITE UPDATE
# Does NOT modify js/main.js or your iOS loader.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$utf8 = New-Object System.Text.UTF8Encoding($false)
$changes = @{}

$pages = @(
  'index.html','about.html','contact.html',
  'services.html','work.html','solutions.html',
  'drevia-crm.html','digiclasss.html',
  'drevia-erp.html','readmynotes.html'
)

$order = @(
  'drevia-crm','digiclasss',
  'drevia-erp','readmynotes'
)

function Replace-One(
  [string]$s,
  [string]$old,
  [string]$new,
  [string]$label
) {
  $n = ([regex]::Matches(
    $s,[regex]::Escape($old)
  )).Count

  if ($n -ne 1) {
    throw "${label}: expected one match, found $n."
  }

  return $s.Replace($old,$new)
}

function Sort-Links(
  [string]$html,
  [string]$outer,
  [string]$inner,
  [string]$label
) {
  $matches = [regex]::Matches($html,$outer)

  if ($matches.Count -ne 1) {
    throw "${label}: expected one menu group."
  }

  $group = $matches[0].Groups['links']
  $links = [regex]::Matches($group.Value,$inner)

  if ($links.Count -ne 4) {
    throw "${label}: expected four links."
  }

  $map = @{}

  foreach ($link in $links) {
    $map[$link.Groups['slug'].Value] = $link.Value
  }

  if ($map.Count -ne 4) {
    throw "${label}: duplicate solution links."
  }

  $sorted = ($script:order | ForEach-Object {
    $map[$_]
  }) -join ''

  return $html.Substring(0,$group.Index) +
    $sorted +
    $html.Substring($group.Index+$group.Length)
}

$groups = @(
  @{
    label='desktop'
    outer='(?s)<div class="menu" role="menu">(?<links>(?:<a href="(?:drevia-crm|digiclasss|drevia-erp|readmynotes)\.html">.*?</a>\s*){4})<a class="all"'
    inner='(?s)<a href="(?<slug>drevia-crm|digiclasss|drevia-erp|readmynotes)\.html">.*?</a>\s*'
  },
  @{
    label='mobile'
    outer='(?s)<div class="drawer"[^>]*>.*?<small>Solutions</small>\s*<a class="s" href="solutions.html">All solutions</a>(?<links>(?:<a class="s" href="(?:drevia-crm|digiclasss|drevia-erp|readmynotes)\.html">.*?</a>\s*){4})'
    inner='(?s)<a class="s" href="(?<slug>drevia-crm|digiclasss|drevia-erp|readmynotes)\.html">.*?</a>\s*'
  },
  @{
    label='footer'
    outer='(?s)<div><h5>Solutions</h5><a href="solutions.html">Overview</a>(?<links>(?:<a href="(?:drevia-crm|digiclasss|drevia-erp|readmynotes)\.html">.*?</a>\s*){4})</div>'
    inner='(?s)<a href="(?<slug>drevia-crm|digiclasss|drevia-erp|readmynotes)\.html">.*?</a>\s*'
  }
)

# HOMEPAGE QUICK NAVIGATION

$quick = @'
<nav class="home-quick" aria-label="Jump to a solution">
<div class="wrap home-quick-in">
  <span>Explore Drevia</span>
  <a href="#home-crm">CRM ↗</a>
  <a href="#home-digiclasss">DigiClasss ↗</a>
  <a href="#home-websites">Business Websites ↗</a>
</div>
</nav>
'@

# TWO DISTINCT HOMEPAGE SECTIONS

$additions = @'
<!-- DigiClasss: dedicated education product -->
<section class="home-product home-digi" id="home-digiclasss">
 <div class="wrap home-product-grid">
  <div class="home-product-copy" data-r="left">
   <span class="home-eyebrow">02 / Education technology</span>
   <h2>DigiClasss. <em>One connected institute.</em></h2>
   <p>Connect institute owners, teachers, students and parents. Manage attendance, fees, assignments, notices and everyday communication from one platform.</p>

   <div class="home-benefits">
    <span>Attendance &amp; fees</span>
    <span>Students &amp; teachers</span>
    <span>Parents &amp; notices</span>
   </div>

   <div class="home-product-buttons">
    <button class="btn p" type="button" data-demo data-demo-product="DigiClasss">Book a Demo ↗</button>
    <a class="btn g" href="digiclasss.html">Know More →</a>
   </div>
  </div>

  <div class="home-preview home-school" data-r="right" aria-label="Illustrative DigiClasss dashboard">
   <div class="home-preview-head">
    <span>🎓 DigiClasss</span>
    <small>● Connected</small>
   </div>
   <div class="home-preview-sub">
    Institute dashboard
    <small>Today's overview</small>
   </div>
   <div class="home-preview-stats">
    <div>
     <small>Attendance</small>
     <strong>94%</strong>
     <span>Illustrative</span>
    </div>
    <div>
     <small>Active students</small>
     <strong>1,240</strong>
     <span>Illustrative</span>
    </div>
   </div>
   <div class="home-preview-notice">
    <span>✓</span>
    <div>
     <b>Notice delivered</b>
     <small>Keep everyone informed</small>
    </div>
   </div>
   <small class="home-preview-disclaimer">Illustrative interface, not live statistics</small>
  </div>
 </div>
</section>

<!-- Business Websites: dedicated service section -->
<section class="home-product home-websites" id="home-websites">
 <div class="wrap">
  <div class="home-product-grid">
   <div class="home-product-copy" data-r="left">
    <span class="home-eyebrow">03 / Websites and web applications</span>
    <h2>A website built <em>for your business.</em></h2>
    <p>From a premium static site to a dynamic platform with an admin panel, e-commerce store or custom web application — tailored to how your business works.</p>

    <div class="home-product-buttons">
     <a class="btn p" href="contact.html">Build Your Website ↗</a>
     <a class="btn g" href="services.html#web">Know More →</a>
    </div>
   </div>

   <div class="home-web-preview" data-r="right" aria-label="Illustrative business website design">
    <div class="home-browser">
     <div class="home-browser-bar">
      <i></i><i></i><i></i>
      <span>yourbusiness.com</span>
     </div>
     <div class="home-browser-body">
      <small>YOUR BUSINESS, ONLINE</small>
      <strong>Make a first impression that lasts.</strong>
      <b>Explore services →</b>
      <div class="home-browser-lines">
       <i></i><i></i><i></i>
      </div>
     </div>
    </div>
    <div class="home-phone">
     <small>MOBILE READY</small>
     <strong>Your brand,<br>everywhere.</strong>
     <i></i><i></i>
    </div>
   </div>
  </div>

  <div class="home-industries" data-r="up">
   <h3>Whatever your business, we can build it.</h3>
   <div class="home-industry-tags">
    <span>Static Websites</span>
    <span>Dynamic Websites + Admin Panel</span>
    <span>E-commerce</span>
    <span>Institute Websites</span>
    <span>Restaurants &amp; Cafés</span>
    <span>Real Estate</span>
    <span>Hospitals &amp; Clinics</span>
    <span>Jewellery Shops</span>
    <span>Business &amp; Office Websites</span>
    <span>Custom Web Apps</span>
   </div>
  </div>
 </div>
</section>
'@

# STYLES: BUTTON FIXES AND HOMEPAGE SECTIONS

$css = @'
/* Targeted CTA contrast fixes */
.erp .end .btn.p,
.notes .end .btn.p {
 color:#fff!important;
 -webkit-text-fill-color:#fff!important;
}

/* Homepage section navigation */
.home #home-crm,
.home #home-digiclasss,
.home #home-websites {
 scroll-margin-top:115px;
}

.home-quick {
 background:#0c1642;
 border-block:1px solid #ffffff24;
 padding:12px 0;
}

.home-quick-in {
 display:flex;
 gap:9px;
 align-items:center;
 flex-wrap:wrap;
}

.home-quick-in>span {
 font-size:11px;
 letter-spacing:.1em;
 text-transform:uppercase;
 color:#a9b9f4;
 font-weight:800;
 margin-right:8px;
}

.home-quick a {
 color:#eef2ff;
 border:1px solid #ffffff35;
 border-radius:99px;
 padding:9px 15px;
 font-size:12px;
 transition:.2s;
}

.home-quick a:hover {
 background:#30438e;
 transform:translateY(-2px);
}

/* Separate product sections */
.home-product {
 padding:clamp(55px,7vw,90px) 0;
 color:#fff;
}

.home-digi {
 background:
 radial-gradient(circle at 80% 25%,#0b747333,transparent 55%),
 #071234;
}

.home-websites {
 background:
 radial-gradient(circle at 12% 28%,#5d6bed33,transparent 55%),
 #090e2c;
 border-top:1px solid #ffffff16;
}

.home-product-grid {
 display:grid;
 grid-template-columns:1fr 1fr;
 gap:clamp(24px,5vw,70px);
 align-items:center;
}

.home-product-copy h2 {
 font-size:clamp(32px,4vw,54px);
 font-weight:800;
 line-height:1.1;
 letter-spacing:-.04em;
 margin:14px 0 18px;
}

.home-product-copy h2 em {
 font-style:normal;
 color:#88e4d8;
}

.home-websites h2 em {
 color:#b5bdff;
}

.home-eyebrow {
 color:#77e3d4;
 font-size:11px;
 letter-spacing:.12em;
 font-weight:800;
 text-transform:uppercase;
}

.home-websites .home-eyebrow {
 color:#b5bdff;
}

.home-product-copy>p {
 color:#c5d1f2;
 max-width:540px;
 line-height:1.75;
 font-size:14px;
}

.home-benefits {
 display:flex;
 gap:9px;
 flex-wrap:wrap;
 margin-top:20px;
}

.home-benefits span {
 border:1px solid #7ce3d34a;
 background:#7ce3d314;
 border-radius:99px;
 padding:8px 11px;
 color:#cbfff4;
 font-size:11px;
}

.home-product-buttons {
 display:flex;
 gap:11px;
 flex-wrap:wrap;
 margin-top:24px;
}

.home-product-buttons .btn {
 min-height:46px;
 padding:12px 18px;
 font-size:13px;
}

.home-product-buttons .btn.p {
 background:linear-gradient(135deg,#0da9aa,#337bd4);
 color:#fff;
}

.home-websites .home-product-buttons .btn.p {
 background:linear-gradient(135deg,#536fce,#7555d1);
}

/* DigiClasss dashboard preview */
.home-preview {
 border:1px solid #8be6d14d;
 background:#111f45;
 border-radius:24px;
 padding:25px;
 box-shadow:0 26px 65px -40px #0f778c;
}

.home-preview-head,
.home-preview-sub {
 display:flex;
 justify-content:space-between;
 align-items:center;
 gap:10px;
}

.home-preview-head {
 font-weight:800;
 padding-bottom:18px;
 border-bottom:1px solid #ffffff20;
}

.home-preview-head small {
 color:#7de9cd;
}

.home-preview-sub {
 padding:20px 0 5px;
 font-size:14px;
}

.home-preview-sub small,
.home-preview-stats small,
.home-preview-stats span,
.home-preview-notice small {
 color:#c1d2ef;
 font-size:11px;
}

.home-preview-stats {
 display:grid;
 grid-template-columns:1fr 1fr;
 gap:12px;
 margin:12px 0 16px;
}

.home-preview-stats>div {
 border:1px solid #ffffff1e;
 background:#ffffff0b;
 padding:18px;
 border-radius:15px;
}

.home-preview-stats strong {
 display:block;
 font-size:clamp(30px,4vw,43px);
 line-height:1.3;
}

.home-preview-stats span {
 color:#82e6d8;
}

.home-preview-notice {
 display:flex;
 gap:12px;
 align-items:center;
 background:#1a73612b;
 border:1px solid #8be6d12d;
 padding:15px;
 border-radius:13px;
}

.home-preview-notice>span {
 background:#157e74;
 border-radius:50%;
 width:32px;
 height:32px;
 display:grid;
 place-items:center;
 flex:none;
}

.home-preview-notice b,
.home-preview-notice small {
 display:block;
}

.home-preview-disclaimer {
 display:block;
 text-align:right;
 color:#8097bc;
 margin-top:12px;
 font-size:10px;
}

/* Business website preview */
.home-web-preview {
 position:relative;
 min-height:290px;
 padding:15px 39px 10px 0;
 display:flex;
 align-items:center;
 justify-content:center;
}

.home-browser {
 width:min(100%,420px);
 border:5px solid #354577;
 border-radius:18px;
 background:#e5ecff;
 color:#1b2859;
 overflow:hidden;
 box-shadow:0 28px 62px -32px #5c71c4;
}

.home-browser-bar {
 height:35px;
 background:#263466;
 display:flex;
 align-items:center;
 gap:5px;
 padding:0 12px;
}

.home-browser-bar i {
 width:6px;
 height:6px;
 background:#a2b4ed;
 border-radius:50%;
}

.home-browser-bar span {
 color:#cbd5ff;
 margin:auto;
 font-size:10px;
}

.home-browser-body {
 background:linear-gradient(125deg,#eef2ff,#d3dfff);
 padding:23px;
 min-height:230px;
}

.home-browser-body small {
 font-size:10px;
 color:#5573b6;
 letter-spacing:.1em;
}

.home-browser-body strong {
 display:block;
 font-size:clamp(19px,2.8vw,29px);
 line-height:1.15;
 margin:13px 0;
 max-width:310px;
 letter-spacing:-.04em;
}

.home-browser-body b {
 display:inline-block;
 padding:9px 12px;
 background:#4b5eb5;
 color:#fff;
 border-radius:7px;
 font-size:10px;
}

.home-browser-lines {
 display:flex;
 gap:7px;
 margin-top:27px;
}

.home-browser-lines i {
 height:9px;
 flex:1;
 border-radius:5px;
 background:#b8c9ef;
}

.home-phone {
 position:absolute;
 right:0;
 bottom:0;
 width:110px;
 min-height:200px;
 border:6px solid #2b3b6d;
 border-radius:20px;
 background:linear-gradient(160deg,#3457b0,#8a60cb);
 padding:30px 10px 15px;
 box-shadow:0 15px 36px -13px #050923;
}

.home-phone small {
 font-size:9px;
}

.home-phone strong {
 display:block;
 font-size:15px;
 line-height:1.3;
 margin:22px 0;
}

.home-phone i {
 display:block;
 background:#ffffff44;
 height:8px;
 border-radius:5px;
 margin-top:10px;
}

.home-phone i:last-child {
 width:65%;
}

.home-industries {
 margin-top:25px;
 border-top:1px solid #ffffff22;
 padding-top:26px;
}

.home-industries h3 {
 font-size:clamp(18px,2.5vw,24px);
 margin-bottom:16px;
}

.home-industry-tags {
 display:flex;
 flex-wrap:wrap;
 gap:9px;
}

.home-industry-tags span {
 padding:10px 14px;
 background:#ffffff0d;
 border:1px solid #ffffff2e;
 border-radius:9px;
 font-size:12px;
 color:#dbe2ff;
}

/* Tablet and mobile */
@media(max-width:880px) {
 .home-product-grid {
  grid-template-columns:1fr;
 }
 .home-preview,
 .home-web-preview {
  max-width:560px;
  width:100%;
  margin:auto;
 }
}

@media(max-width:600px) {
 .home-product {
  padding:50px 0;
 }
 .home-product-copy h2 {
  font-size:34px;
 }
 .home-quick-in>span {
  width:100%;
 }
 .home-quick a {
  font-size:11px;
  padding:8px 10px;
 }
 .home-product-buttons .btn {
  flex:1 1 140px;
  text-align:center;
 }
 .home-preview {
  padding:16px;
 }
 .home-web-preview {
  min-height:250px;
 }
 .home-browser-body {
  padding:15px;
 }
 .home-phone {
  transform:scale(.82);
  transform-origin:right bottom;
 }
 .home-industry-tags {
  flex-wrap:nowrap;
  overflow-x:auto;
  padding-bottom:12px;
  scroll-snap-type:x proximity;
 }
 .home-industry-tags span {
  white-space:nowrap;
  flex:none;
  scroll-snap-align:start;
 }
}
'@

# UPDATE ALL SHARED MENUS AND HOMEPAGE

foreach($page in $pages) {
 $path = Join-Path $root $page

 if(-not (Test-Path $path)) {
  throw "Missing $page. Put script next to index.html."
 }

 $old = [IO.File]::ReadAllText(
  $path,[Text.Encoding]::UTF8
 )
 $new = $old

 foreach($g in $groups) {
  $new = Sort-Links `
   $new $g.outer $g.inner "$page / $($g.label)"
 }

 if($page -eq 'solutions.html') {
  $new = Sort-Links $new `
  '(?s)<div class="accw" id="acc">(?<links>(?:<a class="acc(?: on)?" href="(?:drevia-crm|digiclasss|drevia-erp|readmynotes)\.html"[^>]*>.*?</a>\s*){4})</div></div></section>' `
  '(?s)<a class="acc(?: on)?" href="(?<slug>drevia-crm|digiclasss|drevia-erp|readmynotes)\.html"[^>]*>.*?</a>\s*' `
  'Solutions cards'
 }

 if($page -eq 'index.html') {
  $new = Replace-One $new `
   '<section class="demo">' `
   ($quick+"`n"+'<section class="demo">') `
   'Homepage quick links'

  $new = Replace-One $new `
   '<section class="pad cs">' `
   '<section class="pad cs" id="home-crm">' `
   'CRM section'

  $new = Replace-One $new `
   '<section class="pad" style="padding-top:0">' `
   ($additions+"`n"+'<section class="pad" style="padding-top:0">') `
   'Separate product sections'
 }

 if($new -cne $old) {
  $changes[$path] = $new
 }
}

# UPDATE CSS

$cssPath = Join-Path $root 'css/base.css'
$jsPath = Join-Path $root 'js/demo.js'

if(-not (Test-Path $cssPath)) {
 throw 'Missing css/base.css'
}
if(-not (Test-Path $jsPath)) {
 throw 'Missing js/demo.js'
}

$changes[$cssPath] = [IO.File]::ReadAllText(
 $cssPath,[Text.Encoding]::UTF8
) + "`r`n" + $css

# ALLOW CRM AND DIGICLASSS DEMO REQUESTS

$demo = [IO.File]::ReadAllText(
 $jsPath,[Text.Encoding]::UTF8
)

$demo = Replace-One $demo `
 'var last;' `
 'var last,product="CRM";' `
 'Demo state'

$demo = Replace-One $demo `
 'function open(){last=document.activeElement;' `
 'function open(which){product=which==="DigiClasss"?"DigiClasss":"CRM";document.getElementById("dmt").textContent="Book a Free "+product+" Demo";el.querySelector(".dm-s").textContent=product+" Software by Drevia Infotech";last=document.activeElement;' `
 'Demo heading'

$demo = Replace-One $demo `
 'e.preventDefault();open()}if(e.target===el' `
 'e.preventDefault();open(t.getAttribute("data-demo-product"))}if(e.target===el' `
 'Demo action'

$demo = Replace-One $demo `
 "Request:'Free CRM demo'" `
 "Request:'Free '+product+' demo'" `
 'Demo request'

$demo = Replace-One $demo `
 "drSend(data,'Free CRM demo request: '+g('dn'))" `
 "drSend(data,'Free '+product+' demo request: '+g('dn'))" `
 'Demo email'

$demo = Replace-One $demo `
 "if(location.hash==='#demo')setTimeout(open,3500)" `
 "if(location.hash==='#demo')setTimeout(function(){open('CRM')},3500)" `
 'Demo deep link'

$changes[$jsPath] = $demo

# CREATE BACKUPS BEFORE WRITING FILES

$backup = Join-Path $env:TEMP (
 'DreviaBackup-' +
 (Get-Date -Format 'yyyyMMdd-HHmmss')
)

foreach($path in $changes.Keys) {
 $relative = $path.Substring(
  $root.Length
 ).TrimStart([char[]]@('\','/'))

 $dest = Join-Path $backup $relative

 [IO.Directory]::CreateDirectory(
  (Split-Path -Parent $dest)
 ) | Out-Null

 [IO.File]::Copy($path,$dest,$true)
}

# WRITE THE VERIFIED CHANGES

foreach($path in $changes.Keys) {
 [IO.File]::WriteAllText(
  $path,[string]$changes[$path],$utf8
 )
 Write-Host "UPDATED: $path" -ForegroundColor Green
}

Write-Host "Update complete!" -ForegroundColor Green
Write-Host "Backup: $backup" -ForegroundColor Cyan
Write-Host "js/main.js was NOT modified."
