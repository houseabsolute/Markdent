sub _tests { my $tests = [
           {
             'markdown' => '	foo	baz		bim
',
             'html' => '<pre><code>foo baz     bim
</code></pre>
'
           },
           {
             'markdown' => "    a	a
    \x{1f50}	a
",
             'html' => "<pre><code>a   a
\x{1f50}   a
</code></pre>
"
           },
           {
             'markdown' => '- `one
- two`
',
             'html' => '<ul>
<li>`one</li>
<li>two`</li>
</ul>
'
           },
           {
             'markdown' => '***
---
___
',
             'html' => '<hr />
<hr />
<hr />
'
           },
           {
             'markdown' => '+++
',
             'html' => '<p>+++</p>
'
           },
           {
             'markdown' => '===
',
             'html' => '<p>===</p>
'
           },
           {
             'markdown' => '--
**
__
',
             'html' => '<p>--
**
__</p>
'
           },
           {
             'markdown' => ' ***
  ***
   ***
',
             'html' => '<hr />
<hr />
<hr />
'
           },
           {
             'markdown' => '    ***
',
             'html' => '<pre><code>***
</code></pre>
'
           },
           {
             'markdown' => 'Foo
    ***
',
             'html' => '<p>Foo
***</p>
'
           },
           {
             'markdown' => '_____________________________________
',
             'html' => '<hr />
'
           },
           {
             'markdown' => ' - - -
',
             'html' => '<hr />
'
           },
           {
             'markdown' => ' **  * ** * ** * **
',
             'html' => '<hr />
'
           },
           {
             'markdown' => '-     -      -      -
',
             'html' => '<hr />
'
           },
           {
             'markdown' => '- - - -    
',
             'html' => '<hr />
'
           },
           {
             'markdown' => '_ _ _ _ a

a------

---a---
',
             'html' => '<p>_ _ _ _ a</p>
<p>a------</p>
<p>---a---</p>
'
           },
           {
             'markdown' => ' *-*
',
             'html' => '<p><em>-</em></p>
'
           },
           {
             'markdown' => '- foo
***
- bar
',
             'html' => '<ul>
<li>foo</li>
</ul>
<hr />
<ul>
<li>bar</li>
</ul>
'
           },
           {
             'markdown' => 'Foo
***
bar
',
             'html' => '<p>Foo</p>
<hr />
<p>bar</p>
'
           },
           {
             'markdown' => 'Foo
---
bar
',
             'html' => '<h2>Foo</h2>
<p>bar</p>
'
           },
           {
             'markdown' => '* Foo
* * *
* Bar
',
             'html' => '<ul>
<li>Foo</li>
</ul>
<hr />
<ul>
<li>Bar</li>
</ul>
'
           },
           {
             'markdown' => '- Foo
- * * *
',
             'html' => '<ul>
<li>Foo</li>
<li>
<hr />
</li>
</ul>
'
           },
           {
             'markdown' => '# foo
## foo
### foo
#### foo
##### foo
###### foo
',
             'html' => '<h1>foo</h1>
<h2>foo</h2>
<h3>foo</h3>
<h4>foo</h4>
<h5>foo</h5>
<h6>foo</h6>
'
           },
           {
             'markdown' => '####### foo
',
             'html' => '<p>####### foo</p>
'
           },
           {
             'markdown' => '#5 bolt
',
             'html' => '<p>#5 bolt</p>
'
           },
           {
             'markdown' => '\\## foo
',
             'html' => '<p>## foo</p>
'
           },
           {
             'markdown' => '# foo *bar* \\*baz\\*
',
             'html' => '<h1>foo <em>bar</em> *baz*</h1>
'
           },
           {
             'markdown' => '#                  foo                     
',
             'html' => '<h1>foo</h1>
'
           },
           {
             'markdown' => ' ### foo
  ## foo
   # foo
',
             'html' => '<h3>foo</h3>
<h2>foo</h2>
<h1>foo</h1>
'
           },
           {
             'markdown' => '    # foo
',
             'html' => '<pre><code># foo
</code></pre>
'
           },
           {
             'markdown' => 'foo
    # bar
',
             'html' => '<p>foo
# bar</p>
'
           },
           {
             'markdown' => '## foo ##
  ###   bar    ###
',
             'html' => '<h2>foo</h2>
<h3>bar</h3>
'
           },
           {
             'markdown' => '# foo ##################################
##### foo ##
',
             'html' => '<h1>foo</h1>
<h5>foo</h5>
'
           },
           {
             'markdown' => '### foo ###     
',
             'html' => '<h3>foo</h3>
'
           },
           {
             'markdown' => '### foo ### b
',
             'html' => '<h3>foo ### b</h3>
'
           },
           {
             'markdown' => '# foo#
',
             'html' => '<h1>foo#</h1>
'
           },
           {
             'markdown' => '### foo \\###
## foo #\\##
# foo \\#
',
             'html' => '<h3>foo ###</h3>
<h2>foo ###</h2>
<h1>foo #</h1>
'
           },
           {
             'markdown' => '****
## foo
****
',
             'html' => '<hr />
<h2>foo</h2>
<hr />
'
           },
           {
             'markdown' => 'Foo bar
# baz
Bar foo
',
             'html' => '<p>Foo bar</p>
<h1>baz</h1>
<p>Bar foo</p>
'
           },
           {
             'markdown' => '## 
#
### ###
',
             'html' => '<h2></h2>
<h1></h1>
<h3></h3>
'
           },
           {
             'markdown' => 'Foo *bar*
=========

Foo *bar*
---------
',
             'html' => '<h1>Foo <em>bar</em></h1>
<h2>Foo <em>bar</em></h2>
'
           },
           {
             'markdown' => 'Foo
-------------------------

Foo
=
',
             'html' => '<h2>Foo</h2>
<h1>Foo</h1>
'
           },
           {
             'markdown' => '   Foo
---

  Foo
-----

  Foo
  ===
',
             'html' => '<h2>Foo</h2>
<h2>Foo</h2>
<h1>Foo</h1>
'
           },
           {
             'markdown' => '    Foo
    ---

    Foo
---
',
             'html' => '<pre><code>Foo
---

Foo
</code></pre>
<hr />
'
           },
           {
             'markdown' => 'Foo
   ----      
',
             'html' => '<h2>Foo</h2>
'
           },
           {
             'markdown' => 'Foo
    ---
',
             'html' => '<p>Foo
---</p>
'
           },
           {
             'markdown' => 'Foo
= =

Foo
--- -
',
             'html' => '<p>Foo
= =</p>
<p>Foo</p>
<hr />
'
           },
           {
             'markdown' => 'Foo  
-----
',
             'html' => '<h2>Foo</h2>
'
           },
           {
             'markdown' => 'Foo\\
----
',
             'html' => '<h2>Foo\\</h2>
'
           },
           {
             'markdown' => '`Foo
----
`

<a title="a lot
---
of dashes"/>
',
             'html' => '<h2>`Foo</h2>
<p>`</p>
<h2>&lt;a title=&quot;a lot</h2>
<p>of dashes&quot;/&gt;</p>
'
           },
           {
             'markdown' => '> Foo
---
',
             'html' => '<blockquote>
<p>Foo</p>
</blockquote>
<hr />
'
           },
           {
             'markdown' => '- Foo
---
',
             'html' => '<ul>
<li>Foo</li>
</ul>
<hr />
'
           },
           {
             'markdown' => 'Foo
Bar
---

Foo
Bar
===
',
             'html' => '<p>Foo
Bar</p>
<hr />
<p>Foo
Bar
===</p>
'
           },
           {
             'markdown' => '---
Foo
---
Bar
---
Baz
',
             'html' => '<hr />
<h2>Foo</h2>
<h2>Bar</h2>
<p>Baz</p>
'
           },
           {
             'markdown' => '
====
',
             'html' => '<p>====</p>
'
           },
           {
             'markdown' => '---
---
',
             'html' => '<hr />
<hr />
'
           },
           {
             'markdown' => '- foo
-----
',
             'html' => '<ul>
<li>foo</li>
</ul>
<hr />
'
           },
           {
             'markdown' => '    foo
---
',
             'html' => '<pre><code>foo
</code></pre>
<hr />
'
           },
           {
             'markdown' => '> foo
-----
',
             'html' => '<blockquote>
<p>foo</p>
</blockquote>
<hr />
'
           },
           {
             'markdown' => '\\> foo
------
',
             'html' => '<h2>&gt; foo</h2>
'
           },
           {
             'markdown' => '    a simple
      indented code block
',
             'html' => '<pre><code>a simple
  indented code block
</code></pre>
'
           },
           {
             'markdown' => '    <a/>
    *hi*

    - one
',
             'html' => '<pre><code>&lt;a/&gt;
*hi*

- one
</code></pre>
'
           },
           {
             'markdown' => '    chunk1

    chunk2
  
 
 
    chunk3
',
             'html' => '<pre><code>chunk1

chunk2



chunk3
</code></pre>
'
           },
           {
             'markdown' => '    chunk1
      
      chunk2
',
             'html' => '<pre><code>chunk1
  
  chunk2
</code></pre>
'
           },
           {
             'markdown' => 'Foo
    bar

',
             'html' => '<p>Foo
bar</p>
'
           },
           {
             'markdown' => '    foo
bar
',
             'html' => '<pre><code>foo
</code></pre>
<p>bar</p>
'
           },
           {
             'markdown' => '# Header
    foo
Header
------
    foo
----
',
             'html' => '<h1>Header</h1>
<pre><code>foo
</code></pre>
<h2>Header</h2>
<pre><code>foo
</code></pre>
<hr />
'
           },
           {
             'markdown' => '        foo
    bar
',
             'html' => '<pre><code>    foo
bar
</code></pre>
'
           },
           {
             'markdown' => '
    
    foo
    

',
             'html' => '<pre><code>foo
</code></pre>
'
           },
           {
             'markdown' => '    foo  
',
             'html' => '<pre><code>foo  
</code></pre>
'
           },
           {
             'markdown' => '```
<
 >
```
',
             'html' => '<pre><code>&lt;
 &gt;
</code></pre>
'
           },
           {
             'markdown' => '~~~
<
 >
~~~
',
             'html' => '<pre><code>&lt;
 &gt;
</code></pre>
'
           },
           {
             'markdown' => '```
aaa
~~~
```
',
             'html' => '<pre><code>aaa
~~~
</code></pre>
'
           },
           {
             'markdown' => '~~~
aaa
```
~~~
',
             'html' => '<pre><code>aaa
```
</code></pre>
'
           },
           {
             'markdown' => '````
aaa
```
``````
',
             'html' => '<pre><code>aaa
```
</code></pre>
'
           },
           {
             'markdown' => '~~~~
aaa
~~~
~~~~
',
             'html' => '<pre><code>aaa
~~~
</code></pre>
'
           },
           {
             'markdown' => '```
',
             'html' => '<pre><code></code></pre>
'
           },
           {
             'markdown' => '`````

```
aaa
',
             'html' => '<pre><code>
```
aaa
</code></pre>
'
           },
           {
             'markdown' => '```

  
```
',
             'html' => '<pre><code>
  
</code></pre>
'
           },
           {
             'markdown' => '```
```
',
             'html' => '<pre><code></code></pre>
'
           },
           {
             'markdown' => ' ```
 aaa
aaa
```
',
             'html' => '<pre><code>aaa
aaa
</code></pre>
'
           },
           {
             'markdown' => '  ```
aaa
  aaa
aaa
  ```
',
             'html' => '<pre><code>aaa
aaa
aaa
</code></pre>
'
           },
           {
             'markdown' => '   ```
   aaa
    aaa
  aaa
   ```
',
             'html' => '<pre><code>aaa
 aaa
aaa
</code></pre>
'
           },
           {
             'markdown' => '    ```
    aaa
    ```
',
             'html' => '<pre><code>```
aaa
```
</code></pre>
'
           },
           {
             'markdown' => '```
aaa
  ```
',
             'html' => '<pre><code>aaa
</code></pre>
'
           },
           {
             'markdown' => '   ```
aaa
  ```
',
             'html' => '<pre><code>aaa
</code></pre>
'
           },
           {
             'markdown' => '```
aaa
    ```
',
             'html' => '<pre><code>aaa
    ```
</code></pre>
'
           },
           {
             'markdown' => '``` ```
aaa
',
             'html' => '<p><code></code>
aaa</p>
'
           },
           {
             'markdown' => '~~~~~~
aaa
~~~ ~~
',
             'html' => '<pre><code>aaa
~~~ ~~
</code></pre>
'
           },
           {
             'markdown' => 'foo
```
bar
```
baz
',
             'html' => '<p>foo</p>
<pre><code>bar
</code></pre>
<p>baz</p>
'
           },
           {
             'markdown' => 'foo
---
~~~
bar
~~~
# baz
',
             'html' => '<h2>foo</h2>
<pre><code>bar
</code></pre>
<h1>baz</h1>
'
           },
           {
             'markdown' => '```ruby
def foo(x)
  return 3
end
```
',
             'html' => '<pre><code class="language-ruby">def foo(x)
  return 3
end
</code></pre>
'
           },
           {
             'markdown' => '~~~~    ruby startline=3 $%@#$
def foo(x)
  return 3
end
~~~~~~~
',
             'html' => '<pre><code class="language-ruby">def foo(x)
  return 3
end
</code></pre>
'
           },
           {
             'markdown' => '````;
````
',
             'html' => '<pre><code class="language-;"></code></pre>
'
           },
           {
             'markdown' => '``` aa ```
foo
',
             'html' => '<p><code>aa</code>
foo</p>
'
           },
           {
             'markdown' => '```
``` aaa
```
',
             'html' => '<pre><code>``` aaa
</code></pre>
'
           },
           {
             'markdown' => '<table>
  <tr>
    <td>
           hi
    </td>
  </tr>
</table>

okay.
',
             'html' => '<table>
  <tr>
    <td>
           hi
    </td>
  </tr>
</table>
<p>okay.</p>
'
           },
           {
             'markdown' => ' <div>
  *hello*
         <foo><a>
',
             'html' => ' <div>
  *hello*
         <foo><a>
'
           },
           {
             'markdown' => '<DIV CLASS="foo">

*Markdown*

</DIV>
',
             'html' => '<DIV CLASS="foo">
<p><em>Markdown</em></p>
</DIV>
'
           },
           {
             'markdown' => '<div></div>
``` c
int x = 33;
```
',
             'html' => '<div></div>
``` c
int x = 33;
```
'
           },
           {
             'markdown' => '<!-- Foo
bar
   baz -->
',
             'html' => '<!-- Foo
bar
   baz -->
'
           },
           {
             'markdown' => '<?php
  echo \'>\';
?>
',
             'html' => '<?php
  echo \'>\';
?>
'
           },
           {
             'markdown' => '<![CDATA[
function matchwo(a,b)
{
if (a < b && a < 0) then
  {
  return 1;
  }
else
  {
  return 0;
  }
}
]]>
',
             'html' => '<![CDATA[
function matchwo(a,b)
{
if (a < b && a < 0) then
  {
  return 1;
  }
else
  {
  return 0;
  }
}
]]>
'
           },
           {
             'markdown' => '  <!-- foo -->

    <!-- foo -->
',
             'html' => '  <!-- foo -->
<pre><code>&lt;!-- foo --&gt;
</code></pre>
'
           },
           {
             'markdown' => 'Foo
<div>
bar
</div>
',
             'html' => '<p>Foo</p>
<div>
bar
</div>
'
           },
           {
             'markdown' => '<div>
bar
</div>
*foo*
',
             'html' => '<div>
bar
</div>
*foo*
'
           },
           {
             'markdown' => '<div class
foo
',
             'html' => '<div class
foo
'
           },
           {
             'markdown' => '<div>

*Emphasized* text.

</div>
',
             'html' => '<div>
<p><em>Emphasized</em> text.</p>
</div>
'
           },
           {
             'markdown' => '<div>
*Emphasized* text.
</div>
',
             'html' => '<div>
*Emphasized* text.
</div>
'
           },
           {
             'markdown' => '<table>

<tr>

<td>
Hi
</td>

</tr>

</table>
',
             'html' => '<table>
<tr>
<td>
Hi
</td>
</tr>
</table>
'
           },
           {
             'markdown' => '[foo]: /url "title"

[foo]
',
             'html' => '<p><a href="/url" title="title">foo</a></p>
'
           },
           {
             'markdown' => '   [foo]: 
      /url  
           \'the title\'  

[foo]
',
             'html' => '<p><a href="/url" title="the title">foo</a></p>
'
           },
           {
             'markdown' => '[Foo*bar\\]]:my_(url) \'title (with parens)\'

[Foo*bar\\]]
',
             'html' => '<p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>
'
           },
           {
             'markdown' => '[Foo bar]:
<my url>
\'title\'

[Foo bar]
',
             'html' => '<p><a href="my%20url" title="title">Foo bar</a></p>
'
           },
           {
             'markdown' => '[foo]:
/url

[foo]
',
             'html' => '<p><a href="/url">foo</a></p>
'
           },
           {
             'markdown' => '[foo]:

[foo]
',
             'html' => '<p>[foo]:</p>
<p>[foo]</p>
'
           },
           {
             'markdown' => '[foo]

[foo]: url
',
             'html' => '<p><a href="url">foo</a></p>
'
           },
           {
             'markdown' => '[foo]

[foo]: first
[foo]: second
',
             'html' => '<p><a href="first">foo</a></p>
'
           },
           {
             'markdown' => '[FOO]: /url

[Foo]
',
             'html' => '<p><a href="/url">Foo</a></p>
'
           },
           {
             'markdown' => "[\x{391}\x{393}\x{3a9}]: /\x{3c6}\x{3bf}\x{3c5}

[\x{3b1}\x{3b3}\x{3c9}]
",
             'html' => "<p><a href=\"/%CF%86%CE%BF%CF%85\">\x{3b1}\x{3b3}\x{3c9}</a></p>
"
           },
           {
             'markdown' => '[foo]: /url
',
             'html' => ''
           },
           {
             'markdown' => '[foo]: /url "title" ok
',
             'html' => '<p>[foo]: /url &quot;title&quot; ok</p>
'
           },
           {
             'markdown' => '    [foo]: /url "title"

[foo]
',
             'html' => '<pre><code>[foo]: /url &quot;title&quot;
</code></pre>
<p>[foo]</p>
'
           },
           {
             'markdown' => '```
[foo]: /url
```

[foo]
',
             'html' => '<pre><code>[foo]: /url
</code></pre>
<p>[foo]</p>
'
           },
           {
             'markdown' => 'Foo
[bar]: /baz

[bar]
',
             'html' => '<p>Foo
[bar]: /baz</p>
<p>[bar]</p>
'
           },
           {
             'markdown' => '# [Foo]
[foo]: /url
> bar
',
             'html' => '<h1><a href="/url">Foo</a></h1>
<blockquote>
<p>bar</p>
</blockquote>
'
           },
           {
             'markdown' => '[foo]: /foo-url "foo"
[bar]: /bar-url
  "bar"
[baz]: /baz-url

[foo],
[bar],
[baz]
',
             'html' => '<p><a href="/foo-url" title="foo">foo</a>,
<a href="/bar-url" title="bar">bar</a>,
<a href="/baz-url">baz</a></p>
'
           },
           {
             'markdown' => '[foo]

> [foo]: /url
',
             'html' => '<p><a href="/url">foo</a></p>
<blockquote>
</blockquote>
'
           },
           {
             'markdown' => 'aaa

bbb
',
             'html' => '<p>aaa</p>
<p>bbb</p>
'
           },
           {
             'markdown' => 'aaa
bbb

ccc
ddd
',
             'html' => '<p>aaa
bbb</p>
<p>ccc
ddd</p>
'
           },
           {
             'markdown' => 'aaa


bbb
',
             'html' => '<p>aaa</p>
<p>bbb</p>
'
           },
           {
             'markdown' => '  aaa
 bbb
',
             'html' => '<p>aaa
bbb</p>
'
           },
           {
             'markdown' => 'aaa
             bbb
                                       ccc
',
             'html' => '<p>aaa
bbb
ccc</p>
'
           },
           {
             'markdown' => '   aaa
bbb
',
             'html' => '<p>aaa
bbb</p>
'
           },
           {
             'markdown' => '    aaa
bbb
',
             'html' => '<pre><code>aaa
</code></pre>
<p>bbb</p>
'
           },
           {
             'markdown' => 'aaa     
bbb     
',
             'html' => '<p>aaa<br />
bbb</p>
'
           },
           {
             'markdown' => '  

aaa
  

# aaa

  
',
             'html' => '<p>aaa</p>
<h1>aaa</h1>
'
           },
           {
             'markdown' => '> # Foo
> bar
> baz
',
             'html' => '<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>
'
           },
           {
             'markdown' => '># Foo
>bar
> baz
',
             'html' => '<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>
'
           },
           {
             'markdown' => '   > # Foo
   > bar
 > baz
',
             'html' => '<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>
'
           },
           {
             'markdown' => '    > # Foo
    > bar
    > baz
',
             'html' => '<pre><code>&gt; # Foo
&gt; bar
&gt; baz
</code></pre>
'
           },
           {
             'markdown' => '> # Foo
> bar
baz
',
             'html' => '<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>
'
           },
           {
             'markdown' => '> bar
baz
> foo
',
             'html' => '<blockquote>
<p>bar
baz
foo</p>
</blockquote>
'
           },
           {
             'markdown' => '> foo
---
',
             'html' => '<blockquote>
<p>foo</p>
</blockquote>
<hr />
'
           },
           {
             'markdown' => '> - foo
- bar
',
             'html' => '<blockquote>
<ul>
<li>foo</li>
</ul>
</blockquote>
<ul>
<li>bar</li>
</ul>
'
           },
           {
             'markdown' => '>     foo
    bar
',
             'html' => '<blockquote>
<pre><code>foo
</code></pre>
</blockquote>
<pre><code>bar
</code></pre>
'
           },
           {
             'markdown' => '> ```
foo
```
',
             'html' => '<blockquote>
<pre><code></code></pre>
</blockquote>
<p>foo</p>
<pre><code></code></pre>
'
           },
           {
             'markdown' => '>
',
             'html' => '<blockquote>
</blockquote>
'
           },
           {
             'markdown' => '>
>  
> 
',
             'html' => '<blockquote>
</blockquote>
'
           },
           {
             'markdown' => '>
> foo
>  
',
             'html' => '<blockquote>
<p>foo</p>
</blockquote>
'
           },
           {
             'markdown' => '> foo

> bar
',
             'html' => '<blockquote>
<p>foo</p>
</blockquote>
<blockquote>
<p>bar</p>
</blockquote>
'
           },
           {
             'markdown' => '> foo
> bar
',
             'html' => '<blockquote>
<p>foo
bar</p>
</blockquote>
'
           },
           {
             'markdown' => '> foo
>
> bar
',
             'html' => '<blockquote>
<p>foo</p>
<p>bar</p>
</blockquote>
'
           },
           {
             'markdown' => 'foo
> bar
',
             'html' => '<p>foo</p>
<blockquote>
<p>bar</p>
</blockquote>
'
           },
           {
             'markdown' => '> aaa
***
> bbb
',
             'html' => '<blockquote>
<p>aaa</p>
</blockquote>
<hr />
<blockquote>
<p>bbb</p>
</blockquote>
'
           },
           {
             'markdown' => '> bar
baz
',
             'html' => '<blockquote>
<p>bar
baz</p>
</blockquote>
'
           },
           {
             'markdown' => '> bar

baz
',
             'html' => '<blockquote>
<p>bar</p>
</blockquote>
<p>baz</p>
'
           },
           {
             'markdown' => '> bar
>
baz
',
             'html' => '<blockquote>
<p>bar</p>
</blockquote>
<p>baz</p>
'
           },
           {
             'markdown' => '> > > foo
bar
',
             'html' => '<blockquote>
<blockquote>
<blockquote>
<p>foo
bar</p>
</blockquote>
</blockquote>
</blockquote>
'
           },
           {
             'markdown' => '>>> foo
> bar
>>baz
',
             'html' => '<blockquote>
<blockquote>
<blockquote>
<p>foo
bar
baz</p>
</blockquote>
</blockquote>
</blockquote>
'
           },
           {
             'markdown' => '>     code

>    not code
',
             'html' => '<blockquote>
<pre><code>code
</code></pre>
</blockquote>
<blockquote>
<p>not code</p>
</blockquote>
'
           },
           {
             'markdown' => 'A paragraph
with two lines.

    indented code

> A block quote.
',
             'html' => '<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
'
           },
           {
             'markdown' => '1.  A paragraph
    with two lines.

        indented code

    > A block quote.
',
             'html' => '<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>
'
           },
           {
             'markdown' => '- one

 two
',
             'html' => '<ul>
<li>one</li>
</ul>
<p>two</p>
'
           },
           {
             'markdown' => '- one

  two
',
             'html' => '<ul>
<li>
<p>one</p>
<p>two</p>
</li>
</ul>
'
           },
           {
             'markdown' => ' -    one

     two
',
             'html' => '<ul>
<li>one</li>
</ul>
<pre><code> two
</code></pre>
'
           },
           {
             'markdown' => ' -    one

      two
',
             'html' => '<ul>
<li>
<p>one</p>
<p>two</p>
</li>
</ul>
'
           },
           {
             'markdown' => '   > > 1.  one
>>
>>     two
',
             'html' => '<blockquote>
<blockquote>
<ol>
<li>
<p>one</p>
<p>two</p>
</li>
</ol>
</blockquote>
</blockquote>
'
           },
           {
             'markdown' => '>>- one
>>
  >  > two
',
             'html' => '<blockquote>
<blockquote>
<ul>
<li>one</li>
</ul>
<p>two</p>
</blockquote>
</blockquote>
'
           },
           {
             'markdown' => '- foo

  bar

- foo


  bar

- ```
  foo


  bar
  ```

- baz

  + ```
    foo


    bar
    ```
',
             'html' => '<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
<li>
<p>foo</p>
</li>
</ul>
<p>bar</p>
<ul>
<li>
<pre><code>foo


bar
</code></pre>
</li>
<li>
<p>baz</p>
<ul>
<li>
<pre><code>foo


bar
</code></pre>
</li>
</ul>
</li>
</ul>
'
           },
           {
             'markdown' => '1.  foo

    ```
    bar
    ```

    baz

    > bam
',
             'html' => '<ol>
<li>
<p>foo</p>
<pre><code>bar
</code></pre>
<p>baz</p>
<blockquote>
<p>bam</p>
</blockquote>
</li>
</ol>
'
           },
           {
             'markdown' => '- foo

      bar
',
             'html' => '<ul>
<li>
<p>foo</p>
<pre><code>bar
</code></pre>
</li>
</ul>
'
           },
           {
             'markdown' => '  10.  foo

           bar
',
             'html' => '<ol start="10">
<li>
<p>foo</p>
<pre><code>bar
</code></pre>
</li>
</ol>
'
           },
           {
             'markdown' => '    indented code

paragraph

    more code
',
             'html' => '<pre><code>indented code
</code></pre>
<p>paragraph</p>
<pre><code>more code
</code></pre>
'
           },
           {
             'markdown' => '1.     indented code

   paragraph

       more code
',
             'html' => '<ol>
<li>
<pre><code>indented code
</code></pre>
<p>paragraph</p>
<pre><code>more code
</code></pre>
</li>
</ol>
'
           },
           {
             'markdown' => '1.      indented code

   paragraph

       more code
',
             'html' => '<ol>
<li>
<pre><code> indented code
</code></pre>
<p>paragraph</p>
<pre><code>more code
</code></pre>
</li>
</ol>
'
           },
           {
             'markdown' => '   foo

bar
',
             'html' => '<p>foo</p>
<p>bar</p>
'
           },
           {
             'markdown' => '-    foo

  bar
',
             'html' => '<ul>
<li>foo</li>
</ul>
<p>bar</p>
'
           },
           {
             'markdown' => '-  foo

   bar
',
             'html' => '<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>
'
           },
           {
             'markdown' => '- foo
-
- bar
',
             'html' => '<ul>
<li>foo</li>
<li></li>
<li>bar</li>
</ul>
'
           },
           {
             'markdown' => '- foo
-   
- bar
',
             'html' => '<ul>
<li>foo</li>
<li></li>
<li>bar</li>
</ul>
'
           },
           {
             'markdown' => '1. foo
2.
3. bar
',
             'html' => '<ol>
<li>foo</li>
<li></li>
<li>bar</li>
</ol>
'
           },
           {
             'markdown' => '*
',
             'html' => '<ul>
<li></li>
</ul>
'
           },
           {
             'markdown' => ' 1.  A paragraph
     with two lines.

         indented code

     > A block quote.
',
             'html' => '<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>
'
           },
           {
             'markdown' => '  1.  A paragraph
      with two lines.

          indented code

      > A block quote.
',
             'html' => '<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>
'
           },
           {
             'markdown' => '   1.  A paragraph
       with two lines.

           indented code

       > A block quote.
',
             'html' => '<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>
'
           },
           {
             'markdown' => '    1.  A paragraph
        with two lines.

            indented code

        > A block quote.
',
             'html' => '<pre><code>1.  A paragraph
    with two lines.

        indented code

    &gt; A block quote.
</code></pre>
'
           },
           {
             'markdown' => '  1.  A paragraph
with two lines.

          indented code

      > A block quote.
',
             'html' => '<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>
'
           },
           {
             'markdown' => '  1.  A paragraph
    with two lines.
',
             'html' => '<ol>
<li>A paragraph
with two lines.</li>
</ol>
'
           },
           {
             'markdown' => '> 1. > Blockquote
continued here.
',
             'html' => '<blockquote>
<ol>
<li>
<blockquote>
<p>Blockquote
continued here.</p>
</blockquote>
</li>
</ol>
</blockquote>
'
           },
           {
             'markdown' => '> 1. > Blockquote
> continued here.
',
             'html' => '<blockquote>
<ol>
<li>
<blockquote>
<p>Blockquote
continued here.</p>
</blockquote>
</li>
</ol>
</blockquote>
'
           },
           {
             'markdown' => '- foo
  - bar
    - baz
',
             'html' => '<ul>
<li>foo
<ul>
<li>bar
<ul>
<li>baz</li>
</ul>
</li>
</ul>
</li>
</ul>
'
           },
           {
             'markdown' => '- foo
 - bar
  - baz
',
             'html' => '<ul>
<li>foo</li>
<li>bar</li>
<li>baz</li>
</ul>
'
           },
           {
             'markdown' => '10) foo
    - bar
',
             'html' => '<ol start="10">
<li>foo
<ul>
<li>bar</li>
</ul>
</li>
</ol>
'
           },
           {
             'markdown' => '10) foo
   - bar
',
             'html' => '<ol start="10">
<li>foo</li>
</ol>
<ul>
<li>bar</li>
</ul>
'
           },
           {
             'markdown' => '- - foo
',
             'html' => '<ul>
<li>
<ul>
<li>foo</li>
</ul>
</li>
</ul>
'
           },
           {
             'markdown' => '1. - 2. foo
',
             'html' => '<ol>
<li>
<ul>
<li>
<ol start="2">
<li>foo</li>
</ol>
</li>
</ul>
</li>
</ol>
'
           },
           {
             'markdown' => '- # Foo
- Bar
  ---
  baz
',
             'html' => '<ul>
<li>
<h1>Foo</h1>
</li>
<li>
<h2>Bar</h2>
baz</li>
</ul>
'
           },
           {
             'markdown' => '- foo
- bar
+ baz
',
             'html' => '<ul>
<li>foo</li>
<li>bar</li>
</ul>
<ul>
<li>baz</li>
</ul>
'
           },
           {
             'markdown' => '1. foo
2. bar
3) baz
',
             'html' => '<ol>
<li>foo</li>
<li>bar</li>
</ol>
<ol start="3">
<li>baz</li>
</ol>
'
           },
           {
             'markdown' => 'Foo
- bar
- baz
',
             'html' => '<p>Foo</p>
<ul>
<li>bar</li>
<li>baz</li>
</ul>
'
           },
           {
             'markdown' => 'The number of windows in my house is
14.  The number of doors is 6.
',
             'html' => '<p>The number of windows in my house is</p>
<ol start="14">
<li>The number of doors is 6.</li>
</ol>
'
           },
           {
             'markdown' => '- foo

- bar


- baz
',
             'html' => '<ul>
<li>
<p>foo</p>
</li>
<li>
<p>bar</p>
</li>
</ul>
<ul>
<li>baz</li>
</ul>
'
           },
           {
             'markdown' => '- foo


  bar
- baz
',
             'html' => '<ul>
<li>foo</li>
</ul>
<p>bar</p>
<ul>
<li>baz</li>
</ul>
'
           },
           {
             'markdown' => '- foo
  - bar
    - baz


      bim
',
             'html' => '<ul>
<li>foo
<ul>
<li>bar
<ul>
<li>baz</li>
</ul>
</li>
</ul>
</li>
</ul>
<pre><code>  bim
</code></pre>
'
           },
           {
             'markdown' => '- foo
- bar


- baz
- bim
',
             'html' => '<ul>
<li>foo</li>
<li>bar</li>
</ul>
<ul>
<li>baz</li>
<li>bim</li>
</ul>
'
           },
           {
             'markdown' => '-   foo

    notcode

-   foo


    code
',
             'html' => '<ul>
<li>
<p>foo</p>
<p>notcode</p>
</li>
<li>
<p>foo</p>
</li>
</ul>
<pre><code>code
</code></pre>
'
           },
           {
             'markdown' => '- a
 - b
  - c
   - d
  - e
 - f
- g
',
             'html' => '<ul>
<li>a</li>
<li>b</li>
<li>c</li>
<li>d</li>
<li>e</li>
<li>f</li>
<li>g</li>
</ul>
'
           },
           {
             'markdown' => '- a
- b

- c
',
             'html' => '<ul>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
<li>
<p>c</p>
</li>
</ul>
'
           },
           {
             'markdown' => '* a
*

* c
',
             'html' => '<ul>
<li>
<p>a</p>
</li>
<li></li>
<li>
<p>c</p>
</li>
</ul>
'
           },
           {
             'markdown' => '- a
- b

  c
- d
',
             'html' => '<ul>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
<p>c</p>
</li>
<li>
<p>d</p>
</li>
</ul>
'
           },
           {
             'markdown' => '- a
- b

  [ref]: /url
- d
',
             'html' => '<ul>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
<li>
<p>d</p>
</li>
</ul>
'
           },
           {
             'markdown' => '- a
- ```
  b


  ```
- c
',
             'html' => '<ul>
<li>a</li>
<li>
<pre><code>b


</code></pre>
</li>
<li>c</li>
</ul>
'
           },
           {
             'markdown' => '- a
  - b

    c
- d
',
             'html' => '<ul>
<li>a
<ul>
<li>
<p>b</p>
<p>c</p>
</li>
</ul>
</li>
<li>d</li>
</ul>
'
           },
           {
             'markdown' => '* a
  > b
  >
* c
',
             'html' => '<ul>
<li>a
<blockquote>
<p>b</p>
</blockquote>
</li>
<li>c</li>
</ul>
'
           },
           {
             'markdown' => '- a
  > b
  ```
  c
  ```
- d
',
             'html' => '<ul>
<li>a
<blockquote>
<p>b</p>
</blockquote>
<pre><code>c
</code></pre>
</li>
<li>d</li>
</ul>
'
           },
           {
             'markdown' => '- a
',
             'html' => '<ul>
<li>a</li>
</ul>
'
           },
           {
             'markdown' => '- a
  - b
',
             'html' => '<ul>
<li>a
<ul>
<li>b</li>
</ul>
</li>
</ul>
'
           },
           {
             'markdown' => '* foo
  * bar

  baz
',
             'html' => '<ul>
<li>
<p>foo</p>
<ul>
<li>bar</li>
</ul>
<p>baz</p>
</li>
</ul>
'
           },
           {
             'markdown' => '- a
  - b
  - c

- d
  - e
  - f
',
             'html' => '<ul>
<li>
<p>a</p>
<ul>
<li>b</li>
<li>c</li>
</ul>
</li>
<li>
<p>d</p>
<ul>
<li>e</li>
<li>f</li>
</ul>
</li>
</ul>
'
           },
           {
             'markdown' => '`hi`lo`
',
             'html' => '<p><code>hi</code>lo`</p>
'
           },
           {
             'markdown' => '\\!\\"\\#\\$\\%\\&\\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\\\]\\^\\_\\`\\{\\|\\}\\~
',
             'html' => '<p>!&quot;#$%&amp;\'()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~</p>
'
           },
           {
             'markdown' => "\\	\\A\\a\\ \\3\\\x{3c6}\\\x{ab}
",
             'html' => "<p>\\   \\A\\a\\ \\3\\\x{3c6}\\\x{ab}</p>
"
           },
           {
             'markdown' => '\\*not emphasized*
\\<br/> not a tag
\\[not a link](/foo)
\\`not code`
1\\. not a list
\\* not a list
\\# not a header
\\[foo]: /url "not a reference"
',
             'html' => '<p>*not emphasized*
&lt;br/&gt; not a tag
[not a link](/foo)
`not code`
1. not a list
* not a list
# not a header
[foo]: /url &quot;not a reference&quot;</p>
'
           },
           {
             'markdown' => '\\\\*emphasis*
',
             'html' => '<p>\\<em>emphasis</em></p>
'
           },
           {
             'markdown' => 'foo\\
bar
',
             'html' => '<p>foo<br />
bar</p>
'
           },
           {
             'markdown' => '`` \\[\\` ``
',
             'html' => '<p><code>\\[\\`</code></p>
'
           },
           {
             'markdown' => '    \\[\\]
',
             'html' => '<pre><code>\\[\\]
</code></pre>
'
           },
           {
             'markdown' => '~~~
\\[\\]
~~~
',
             'html' => '<pre><code>\\[\\]
</code></pre>
'
           },
           {
             'markdown' => '<http://example.com?find=\\*>
',
             'html' => '<p><a href="http://example.com?find=%5C*">http://example.com?find=\\*</a></p>
'
           },
           {
             'markdown' => '<a href="/bar\\/)">
',
             'html' => '<p><a href="/bar\\/)"></p>
'
           },
           {
             'markdown' => '[foo](/bar\\* "ti\\*tle")
',
             'html' => '<p><a href="/bar*" title="ti*tle">foo</a></p>
'
           },
           {
             'markdown' => '[foo]

[foo]: /bar\\* "ti\\*tle"
',
             'html' => '<p><a href="/bar*" title="ti*tle">foo</a></p>
'
           },
           {
             'markdown' => '``` foo\\+bar
foo
```
',
             'html' => '<pre><code class="language-foo+bar">foo
</code></pre>
'
           },
           {
             'markdown' => '&nbsp; &amp; &copy; &AElig; &Dcaron; &frac34; &HilbertSpace; &DifferentialD; &ClockwiseContourIntegral;
',
             'html' => "<p>\x{a0} &amp; \x{a9} \x{c6} \x{10e} \x{be} \x{210b} \x{2146} \x{2232}</p>
"
           },
           {
             'markdown' => '&#35; &#1234; &#992; &#98765432;
',
             'html' => "<p># \x{4d2} \x{3e0} \x{fffd}</p>
"
           },
           {
             'markdown' => '&#X22; &#XD06; &#xcab;
',
             'html' => "<p>&quot; \x{d06} \x{cab}</p>
"
           },
           {
             'markdown' => '&nbsp &x; &#; &#x; &ThisIsWayTooLongToBeAnEntityIsntIt; &hi?;
',
             'html' => '<p>&amp;nbsp &amp;x; &amp;#; &amp;#x; &amp;ThisIsWayTooLongToBeAnEntityIsntIt; &amp;hi?;</p>
'
           },
           {
             'markdown' => '&copy
',
             'html' => '<p>&amp;copy</p>
'
           },
           {
             'markdown' => '&MadeUpEntity;
',
             'html' => '<p>&amp;MadeUpEntity;</p>
'
           },
           {
             'markdown' => '<a href="&ouml;&ouml;.html">
',
             'html' => '<p><a href="&ouml;&ouml;.html"></p>
'
           },
           {
             'markdown' => '[foo](/f&ouml;&ouml; "f&ouml;&ouml;")
',
             'html' => "<p><a href=\"/f%C3%B6%C3%B6\" title=\"f\x{f6}\x{f6}\">foo</a></p>
"
           },
           {
             'markdown' => '[foo]

[foo]: /f&ouml;&ouml; "f&ouml;&ouml;"
',
             'html' => "<p><a href=\"/f%C3%B6%C3%B6\" title=\"f\x{f6}\x{f6}\">foo</a></p>
"
           },
           {
             'markdown' => '``` f&ouml;&ouml;
foo
```
',
             'html' => "<pre><code class=\"language-f\x{f6}\x{f6}\">foo
</code></pre>
"
           },
           {
             'markdown' => '`f&ouml;&ouml;`
',
             'html' => '<p><code>f&amp;ouml;&amp;ouml;</code></p>
'
           },
           {
             'markdown' => '    f&ouml;f&ouml;
',
             'html' => '<pre><code>f&amp;ouml;f&amp;ouml;
</code></pre>
'
           },
           {
             'markdown' => '`foo`
',
             'html' => '<p><code>foo</code></p>
'
           },
           {
             'markdown' => '`` foo ` bar  ``
',
             'html' => '<p><code>foo ` bar</code></p>
'
           },
           {
             'markdown' => '` `` `
',
             'html' => '<p><code>``</code></p>
'
           },
           {
             'markdown' => '``
foo
``
',
             'html' => '<p><code>foo</code></p>
'
           },
           {
             'markdown' => '`foo   bar
  baz`
',
             'html' => '<p><code>foo bar baz</code></p>
'
           },
           {
             'markdown' => '`foo `` bar`
',
             'html' => '<p><code>foo `` bar</code></p>
'
           },
           {
             'markdown' => '`foo\\`bar`
',
             'html' => '<p><code>foo\\</code>bar`</p>
'
           },
           {
             'markdown' => '*foo`*`
',
             'html' => '<p>*foo<code>*</code></p>
'
           },
           {
             'markdown' => '[not a `link](/foo`)
',
             'html' => '<p>[not a <code>link](/foo</code>)</p>
'
           },
           {
             'markdown' => '<http://foo.bar.`baz>`
',
             'html' => '<p><a href="http://foo.bar.%60baz">http://foo.bar.`baz</a>`</p>
'
           },
           {
             'markdown' => '<a href="`">`
',
             'html' => '<p><a href="`">`</p>
'
           },
           {
             'markdown' => '```foo``
',
             'html' => '<p>```foo``</p>
'
           },
           {
             'markdown' => '`foo
',
             'html' => '<p>`foo</p>
'
           },
           {
             'markdown' => '*foo bar*
',
             'html' => '<p><em>foo bar</em></p>
'
           },
           {
             'markdown' => 'a * foo bar*
',
             'html' => '<p>a * foo bar*</p>
'
           },
           {
             'markdown' => 'a*"foo"*
',
             'html' => '<p>a*&quot;foo&quot;*</p>
'
           },
           {
             'markdown' => "*\x{a0}a\x{a0}*
",
             'html' => "<p>*\x{a0}a\x{a0}*</p>
"
           },
           {
             'markdown' => 'foo*bar*
',
             'html' => '<p>foo<em>bar</em></p>
'
           },
           {
             'markdown' => '5*6*78
',
             'html' => '<p>5<em>6</em>78</p>
'
           },
           {
             'markdown' => '_foo bar_
',
             'html' => '<p><em>foo bar</em></p>
'
           },
           {
             'markdown' => '_ foo bar_
',
             'html' => '<p>_ foo bar_</p>
'
           },
           {
             'markdown' => 'a_"foo"_
',
             'html' => '<p>a_&quot;foo&quot;_</p>
'
           },
           {
             'markdown' => 'foo_bar_
',
             'html' => '<p>foo_bar_</p>
'
           },
           {
             'markdown' => '5_6_78
',
             'html' => '<p>5_6_78</p>
'
           },
           {
             'markdown' => "\x{43f}\x{440}\x{438}\x{441}\x{442}\x{430}\x{43d}\x{44f}\x{43c}_\x{441}\x{442}\x{440}\x{435}\x{43c}\x{44f}\x{442}\x{441}\x{44f}_
",
             'html' => "<p>\x{43f}\x{440}\x{438}\x{441}\x{442}\x{430}\x{43d}\x{44f}\x{43c}<em>\x{441}\x{442}\x{440}\x{435}\x{43c}\x{44f}\x{442}\x{441}\x{44f}</em></p>
"
           },
           {
             'markdown' => '_foo*
',
             'html' => '<p>_foo*</p>
'
           },
           {
             'markdown' => '*foo bar *
',
             'html' => '<p>*foo bar *</p>
'
           },
           {
             'markdown' => '*(*foo)
',
             'html' => '<p>*(*foo)</p>
'
           },
           {
             'markdown' => '*(*foo*)*
',
             'html' => '<p><em>(<em>foo</em>)</em></p>
'
           },
           {
             'markdown' => '*foo*bar
',
             'html' => '<p><em>foo</em>bar</p>
'
           },
           {
             'markdown' => '_foo bar _
',
             'html' => '<p>_foo bar _</p>
'
           },
           {
             'markdown' => '_(_foo)
',
             'html' => '<p>_(_foo)</p>
'
           },
           {
             'markdown' => '_(_foo_)_
',
             'html' => '<p><em>(<em>foo</em>)</em></p>
'
           },
           {
             'markdown' => '_foo_bar
',
             'html' => '<p>_foo_bar</p>
'
           },
           {
             'markdown' => "_\x{43f}\x{440}\x{438}\x{441}\x{442}\x{430}\x{43d}\x{44f}\x{43c}_\x{441}\x{442}\x{440}\x{435}\x{43c}\x{44f}\x{442}\x{441}\x{44f}
",
             'html' => "<p><em>\x{43f}\x{440}\x{438}\x{441}\x{442}\x{430}\x{43d}\x{44f}\x{43c}</em>\x{441}\x{442}\x{440}\x{435}\x{43c}\x{44f}\x{442}\x{441}\x{44f}</p>
"
           },
           {
             'markdown' => '_foo_bar_baz_
',
             'html' => '<p><em>foo_bar_baz</em></p>
'
           },
           {
             'markdown' => '**foo bar**
',
             'html' => '<p><strong>foo bar</strong></p>
'
           },
           {
             'markdown' => '** foo bar**
',
             'html' => '<p>** foo bar**</p>
'
           },
           {
             'markdown' => 'a**"foo"**
',
             'html' => '<p>a**&quot;foo&quot;**</p>
'
           },
           {
             'markdown' => 'foo**bar**
',
             'html' => '<p>foo<strong>bar</strong></p>
'
           },
           {
             'markdown' => '__foo bar__
',
             'html' => '<p><strong>foo bar</strong></p>
'
           },
           {
             'markdown' => '__ foo bar__
',
             'html' => '<p>__ foo bar__</p>
'
           },
           {
             'markdown' => 'a__"foo"__
',
             'html' => '<p>a__&quot;foo&quot;__</p>
'
           },
           {
             'markdown' => 'foo__bar__
',
             'html' => '<p>foo__bar__</p>
'
           },
           {
             'markdown' => '5__6__78
',
             'html' => '<p>5__6__78</p>
'
           },
           {
             'markdown' => "\x{43f}\x{440}\x{438}\x{441}\x{442}\x{430}\x{43d}\x{44f}\x{43c}__\x{441}\x{442}\x{440}\x{435}\x{43c}\x{44f}\x{442}\x{441}\x{44f}__
",
             'html' => "<p>\x{43f}\x{440}\x{438}\x{441}\x{442}\x{430}\x{43d}\x{44f}\x{43c}<strong>\x{441}\x{442}\x{440}\x{435}\x{43c}\x{44f}\x{442}\x{441}\x{44f}</strong></p>
"
           },
           {
             'markdown' => '__foo, __bar__, baz__
',
             'html' => '<p><strong>foo, <strong>bar</strong>, baz</strong></p>
'
           },
           {
             'markdown' => '**foo bar **
',
             'html' => '<p>**foo bar **</p>
'
           },
           {
             'markdown' => '**(**foo)
',
             'html' => '<p>**(**foo)</p>
'
           },
           {
             'markdown' => '*(**foo**)*
',
             'html' => '<p><em>(<strong>foo</strong>)</em></p>
'
           },
           {
             'markdown' => '**Gomphocarpus (*Gomphocarpus physocarpus*, syn.
*Asclepias physocarpa*)**
',
             'html' => '<p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.
<em>Asclepias physocarpa</em>)</strong></p>
'
           },
           {
             'markdown' => '**foo "*bar*" foo**
',
             'html' => '<p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>
'
           },
           {
             'markdown' => '**foo**bar
',
             'html' => '<p><strong>foo</strong>bar</p>
'
           },
           {
             'markdown' => '__foo bar __
',
             'html' => '<p>__foo bar __</p>
'
           },
           {
             'markdown' => '__(__foo)
',
             'html' => '<p>__(__foo)</p>
'
           },
           {
             'markdown' => '_(__foo__)_
',
             'html' => '<p><em>(<strong>foo</strong>)</em></p>
'
           },
           {
             'markdown' => '__foo__bar
',
             'html' => '<p>__foo__bar</p>
'
           },
           {
             'markdown' => "__\x{43f}\x{440}\x{438}\x{441}\x{442}\x{430}\x{43d}\x{44f}\x{43c}__\x{441}\x{442}\x{440}\x{435}\x{43c}\x{44f}\x{442}\x{441}\x{44f}
",
             'html' => "<p><strong>\x{43f}\x{440}\x{438}\x{441}\x{442}\x{430}\x{43d}\x{44f}\x{43c}</strong>\x{441}\x{442}\x{440}\x{435}\x{43c}\x{44f}\x{442}\x{441}\x{44f}</p>
"
           },
           {
             'markdown' => '__foo__bar__baz__
',
             'html' => '<p><strong>foo__bar__baz</strong></p>
'
           },
           {
             'markdown' => '*foo [bar](/url)*
',
             'html' => '<p><em>foo <a href="/url">bar</a></em></p>
'
           },
           {
             'markdown' => '*foo
bar*
',
             'html' => '<p><em>foo
bar</em></p>
'
           },
           {
             'markdown' => '_foo __bar__ baz_
',
             'html' => '<p><em>foo <strong>bar</strong> baz</em></p>
'
           },
           {
             'markdown' => '_foo _bar_ baz_
',
             'html' => '<p><em>foo <em>bar</em> baz</em></p>
'
           },
           {
             'markdown' => '__foo_ bar_
',
             'html' => '<p><em><em>foo</em> bar</em></p>
'
           },
           {
             'markdown' => '*foo *bar**
',
             'html' => '<p><em>foo <em>bar</em></em></p>
'
           },
           {
             'markdown' => '*foo **bar** baz*
',
             'html' => '<p><em>foo <strong>bar</strong> baz</em></p>
'
           },
           {
             'markdown' => '*foo**bar**baz*
',
             'html' => '<p><em>foo</em><em>bar</em><em>baz</em></p>
'
           },
           {
             'markdown' => '***foo** bar*
',
             'html' => '<p><em><strong>foo</strong> bar</em></p>
'
           },
           {
             'markdown' => '*foo **bar***
',
             'html' => '<p><em>foo <strong>bar</strong></em></p>
'
           },
           {
             'markdown' => '*foo**bar***
',
             'html' => '<p><em>foo</em><em>bar</em>**</p>
'
           },
           {
             'markdown' => '*foo **bar *baz* bim** bop*
',
             'html' => '<p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>
'
           },
           {
             'markdown' => '*foo [*bar*](/url)*
',
             'html' => '<p><em>foo <a href="/url"><em>bar</em></a></em></p>
'
           },
           {
             'markdown' => '** is not an empty emphasis
',
             'html' => '<p>** is not an empty emphasis</p>
'
           },
           {
             'markdown' => '**** is not an empty strong emphasis
',
             'html' => '<p>**** is not an empty strong emphasis</p>
'
           },
           {
             'markdown' => '**foo [bar](/url)**
',
             'html' => '<p><strong>foo <a href="/url">bar</a></strong></p>
'
           },
           {
             'markdown' => '**foo
bar**
',
             'html' => '<p><strong>foo
bar</strong></p>
'
           },
           {
             'markdown' => '__foo _bar_ baz__
',
             'html' => '<p><strong>foo <em>bar</em> baz</strong></p>
'
           },
           {
             'markdown' => '__foo __bar__ baz__
',
             'html' => '<p><strong>foo <strong>bar</strong> baz</strong></p>
'
           },
           {
             'markdown' => '____foo__ bar__
',
             'html' => '<p><strong><strong>foo</strong> bar</strong></p>
'
           },
           {
             'markdown' => '**foo **bar****
',
             'html' => '<p><strong>foo <strong>bar</strong></strong></p>
'
           },
           {
             'markdown' => '**foo *bar* baz**
',
             'html' => '<p><strong>foo <em>bar</em> baz</strong></p>
'
           },
           {
             'markdown' => '**foo*bar*baz**
',
             'html' => '<p><em><em>foo</em>bar</em>baz**</p>
'
           },
           {
             'markdown' => '***foo* bar**
',
             'html' => '<p><strong><em>foo</em> bar</strong></p>
'
           },
           {
             'markdown' => '**foo *bar***
',
             'html' => '<p><strong>foo <em>bar</em></strong></p>
'
           },
           {
             'markdown' => '**foo *bar **baz**
bim* bop**
',
             'html' => '<p><strong>foo <em>bar <strong>baz</strong>
bim</em> bop</strong></p>
'
           },
           {
             'markdown' => '**foo [*bar*](/url)**
',
             'html' => '<p><strong>foo <a href="/url"><em>bar</em></a></strong></p>
'
           },
           {
             'markdown' => '__ is not an empty emphasis
',
             'html' => '<p>__ is not an empty emphasis</p>
'
           },
           {
             'markdown' => '____ is not an empty strong emphasis
',
             'html' => '<p>____ is not an empty strong emphasis</p>
'
           },
           {
             'markdown' => 'foo ***
',
             'html' => '<p>foo ***</p>
'
           },
           {
             'markdown' => 'foo *\\**
',
             'html' => '<p>foo <em>*</em></p>
'
           },
           {
             'markdown' => 'foo *_*
',
             'html' => '<p>foo <em>_</em></p>
'
           },
           {
             'markdown' => 'foo *****
',
             'html' => '<p>foo *****</p>
'
           },
           {
             'markdown' => 'foo **\\***
',
             'html' => '<p>foo <strong>*</strong></p>
'
           },
           {
             'markdown' => 'foo **_**
',
             'html' => '<p>foo <strong>_</strong></p>
'
           },
           {
             'markdown' => '**foo*
',
             'html' => '<p>*<em>foo</em></p>
'
           },
           {
             'markdown' => '*foo**
',
             'html' => '<p><em>foo</em>*</p>
'
           },
           {
             'markdown' => '***foo**
',
             'html' => '<p>*<strong>foo</strong></p>
'
           },
           {
             'markdown' => '****foo*
',
             'html' => '<p>***<em>foo</em></p>
'
           },
           {
             'markdown' => '**foo***
',
             'html' => '<p><strong>foo</strong>*</p>
'
           },
           {
             'markdown' => '*foo****
',
             'html' => '<p><em>foo</em>***</p>
'
           },
           {
             'markdown' => 'foo ___
',
             'html' => '<p>foo ___</p>
'
           },
           {
             'markdown' => 'foo _\\__
',
             'html' => '<p>foo <em>_</em></p>
'
           },
           {
             'markdown' => 'foo _*_
',
             'html' => '<p>foo <em>*</em></p>
'
           },
           {
             'markdown' => 'foo _____
',
             'html' => '<p>foo _____</p>
'
           },
           {
             'markdown' => 'foo __\\___
',
             'html' => '<p>foo <strong>_</strong></p>
'
           },
           {
             'markdown' => 'foo __*__
',
             'html' => '<p>foo <strong>*</strong></p>
'
           },
           {
             'markdown' => '__foo_
',
             'html' => '<p>_<em>foo</em></p>
'
           },
           {
             'markdown' => '_foo__
',
             'html' => '<p><em>foo</em>_</p>
'
           },
           {
             'markdown' => '___foo__
',
             'html' => '<p>_<strong>foo</strong></p>
'
           },
           {
             'markdown' => '____foo_
',
             'html' => '<p>___<em>foo</em></p>
'
           },
           {
             'markdown' => '__foo___
',
             'html' => '<p><strong>foo</strong>_</p>
'
           },
           {
             'markdown' => '_foo____
',
             'html' => '<p><em>foo</em>___</p>
'
           },
           {
             'markdown' => '**foo**
',
             'html' => '<p><strong>foo</strong></p>
'
           },
           {
             'markdown' => '*_foo_*
',
             'html' => '<p><em><em>foo</em></em></p>
'
           },
           {
             'markdown' => '__foo__
',
             'html' => '<p><strong>foo</strong></p>
'
           },
           {
             'markdown' => '_*foo*_
',
             'html' => '<p><em><em>foo</em></em></p>
'
           },
           {
             'markdown' => '****foo****
',
             'html' => '<p><strong><strong>foo</strong></strong></p>
'
           },
           {
             'markdown' => '____foo____
',
             'html' => '<p><strong><strong>foo</strong></strong></p>
'
           },
           {
             'markdown' => '******foo******
',
             'html' => '<p><strong><strong><strong>foo</strong></strong></strong></p>
'
           },
           {
             'markdown' => '***foo***
',
             'html' => '<p><strong><em>foo</em></strong></p>
'
           },
           {
             'markdown' => '_____foo_____
',
             'html' => '<p><strong><strong><em>foo</em></strong></strong></p>
'
           },
           {
             'markdown' => '*foo _bar* baz_
',
             'html' => '<p><em>foo _bar</em> baz_</p>
'
           },
           {
             'markdown' => '**foo*bar**
',
             'html' => '<p><em><em>foo</em>bar</em>*</p>
'
           },
           {
             'markdown' => '**foo **bar baz**
',
             'html' => '<p>**foo <strong>bar baz</strong></p>
'
           },
           {
             'markdown' => '*foo *bar baz*
',
             'html' => '<p>*foo <em>bar baz</em></p>
'
           },
           {
             'markdown' => '*[bar*](/url)
',
             'html' => '<p>*<a href="/url">bar*</a></p>
'
           },
           {
             'markdown' => '_foo [bar_](/url)
',
             'html' => '<p>_foo <a href="/url">bar_</a></p>
'
           },
           {
             'markdown' => '*<img src="foo" title="*"/>
',
             'html' => '<p>*<img src="foo" title="*"/></p>
'
           },
           {
             'markdown' => '**<a href="**">
',
             'html' => '<p>**<a href="**"></p>
'
           },
           {
             'markdown' => '__<a href="__">
',
             'html' => '<p>__<a href="__"></p>
'
           },
           {
             'markdown' => '*a `*`*
',
             'html' => '<p><em>a <code>*</code></em></p>
'
           },
           {
             'markdown' => '_a `_`_
',
             'html' => '<p><em>a <code>_</code></em></p>
'
           },
           {
             'markdown' => '**a<http://foo.bar?q=**>
',
             'html' => '<p>**a<a href="http://foo.bar?q=**">http://foo.bar?q=**</a></p>
'
           },
           {
             'markdown' => '__a<http://foo.bar?q=__>
',
             'html' => '<p>__a<a href="http://foo.bar?q=__">http://foo.bar?q=__</a></p>
'
           },
           {
             'markdown' => '[link](/uri "title")
',
             'html' => '<p><a href="/uri" title="title">link</a></p>
'
           },
           {
             'markdown' => '[link](/uri)
',
             'html' => '<p><a href="/uri">link</a></p>
'
           },
           {
             'markdown' => '[link]()
',
             'html' => '<p><a href="">link</a></p>
'
           },
           {
             'markdown' => '[link](<>)
',
             'html' => '<p><a href="">link</a></p>
'
           },
           {
             'markdown' => '[link](/my uri)
',
             'html' => '<p>[link](/my uri)</p>
'
           },
           {
             'markdown' => '[link](</my uri>)
',
             'html' => '<p><a href="/my%20uri">link</a></p>
'
           },
           {
             'markdown' => '[link](foo
bar)
',
             'html' => '<p>[link](foo
bar)</p>
'
           },
           {
             'markdown' => '[link]((foo)and(bar))
',
             'html' => '<p><a href="(foo)and(bar)">link</a></p>
'
           },
           {
             'markdown' => '[link](foo(and(bar)))
',
             'html' => '<p>[link](foo(and(bar)))</p>
'
           },
           {
             'markdown' => '[link](foo(and\\(bar\\)))
',
             'html' => '<p><a href="foo(and(bar))">link</a></p>
'
           },
           {
             'markdown' => '[link](<foo(and(bar))>)
',
             'html' => '<p><a href="foo(and(bar))">link</a></p>
'
           },
           {
             'markdown' => '[link](foo\\)\\:)
',
             'html' => '<p><a href="foo):">link</a></p>
'
           },
           {
             'markdown' => '[link](foo%20b&auml;)
',
             'html' => '<p><a href="foo%20b%C3%A4">link</a></p>
'
           },
           {
             'markdown' => '[link]("title")
',
             'html' => '<p><a href="%22title%22">link</a></p>
'
           },
           {
             'markdown' => '[link](/url "title")
[link](/url \'title\')
[link](/url (title))
',
             'html' => '<p><a href="/url" title="title">link</a>
<a href="/url" title="title">link</a>
<a href="/url" title="title">link</a></p>
'
           },
           {
             'markdown' => '[link](/url "title \\"&quot;")
',
             'html' => '<p><a href="/url" title="title &quot;&quot;">link</a></p>
'
           },
           {
             'markdown' => '[link](/url "title "and" title")
',
             'html' => '<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>
'
           },
           {
             'markdown' => '[link](/url \'title "and" title\')
',
             'html' => '<p><a href="/url" title="title &quot;and&quot; title">link</a></p>
'
           },
           {
             'markdown' => '[link](   /uri
  "title"  )
',
             'html' => '<p><a href="/uri" title="title">link</a></p>
'
           },
           {
             'markdown' => '[link] (/uri)
',
             'html' => '<p>[link] (/uri)</p>
'
           },
           {
             'markdown' => '[link [foo [bar]]](/uri)
',
             'html' => '<p><a href="/uri">link [foo [bar]]</a></p>
'
           },
           {
             'markdown' => '[link] bar](/uri)
',
             'html' => '<p>[link] bar](/uri)</p>
'
           },
           {
             'markdown' => '[link [bar](/uri)
',
             'html' => '<p>[link <a href="/uri">bar</a></p>
'
           },
           {
             'markdown' => '[link \\[bar](/uri)
',
             'html' => '<p><a href="/uri">link [bar</a></p>
'
           },
           {
             'markdown' => '[link *foo **bar** `#`*](/uri)
',
             'html' => '<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
'
           },
           {
             'markdown' => '[![moon](moon.jpg)](/uri)
',
             'html' => '<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
'
           },
           {
             'markdown' => '[foo [bar](/uri)](/uri)
',
             'html' => '<p>[foo <a href="/uri">bar</a>](/uri)</p>
'
           },
           {
             'markdown' => '[foo *[bar [baz](/uri)](/uri)*](/uri)
',
             'html' => '<p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>
'
           },
           {
             'markdown' => '![[[foo](uri1)](uri2)](uri3)
',
             'html' => '<p><img src="uri3" alt="[foo](uri2)" /></p>
'
           },
           {
             'markdown' => '*[foo*](/uri)
',
             'html' => '<p>*<a href="/uri">foo*</a></p>
'
           },
           {
             'markdown' => '[foo *bar](baz*)
',
             'html' => '<p><a href="baz*">foo *bar</a></p>
'
           },
           {
             'markdown' => '[foo <bar attr="](baz)">
',
             'html' => '<p>[foo <bar attr="](baz)"></p>
'
           },
           {
             'markdown' => '[foo`](/uri)`
',
             'html' => '<p>[foo<code>](/uri)</code></p>
'
           },
           {
             'markdown' => '[foo<http://example.com?search=](uri)>
',
             'html' => '<p>[foo<a href="http://example.com?search=%5D(uri)">http://example.com?search=](uri)</a></p>
'
           },
           {
             'markdown' => '[foo][bar]

[bar]: /url "title"
',
             'html' => '<p><a href="/url" title="title">foo</a></p>
'
           },
           {
             'markdown' => '[link [foo [bar]]][ref]

[ref]: /uri
',
             'html' => '<p><a href="/uri">link [foo [bar]]</a></p>
'
           },
           {
             'markdown' => '[link \\[bar][ref]

[ref]: /uri
',
             'html' => '<p><a href="/uri">link [bar</a></p>
'
           },
           {
             'markdown' => '[link *foo **bar** `#`*][ref]

[ref]: /uri
',
             'html' => '<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
'
           },
           {
             'markdown' => '[![moon](moon.jpg)][ref]

[ref]: /uri
',
             'html' => '<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
'
           },
           {
             'markdown' => '[foo [bar](/uri)][ref]

[ref]: /uri
',
             'html' => '<p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>
'
           },
           {
             'markdown' => '[foo *bar [baz][ref]*][ref]

[ref]: /uri
',
             'html' => '<p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>
'
           },
           {
             'markdown' => '*[foo*][ref]

[ref]: /uri
',
             'html' => '<p>*<a href="/uri">foo*</a></p>
'
           },
           {
             'markdown' => '[foo *bar][ref]

[ref]: /uri
',
             'html' => '<p><a href="/uri">foo *bar</a></p>
'
           },
           {
             'markdown' => '[foo <bar attr="][ref]">

[ref]: /uri
',
             'html' => '<p>[foo <bar attr="][ref]"></p>
'
           },
           {
             'markdown' => '[foo`][ref]`

[ref]: /uri
',
             'html' => '<p>[foo<code>][ref]</code></p>
'
           },
           {
             'markdown' => '[foo<http://example.com?search=][ref]>

[ref]: /uri
',
             'html' => '<p>[foo<a href="http://example.com?search=%5D%5Bref%5D">http://example.com?search=][ref]</a></p>
'
           },
           {
             'markdown' => '[foo][BaR]

[bar]: /url "title"
',
             'html' => '<p><a href="/url" title="title">foo</a></p>
'
           },
           {
             'markdown' => "[\x{422}\x{43e}\x{43b}\x{43f}\x{43e}\x{439}][\x{422}\x{43e}\x{43b}\x{43f}\x{43e}\x{439}] is a Russian word.

[\x{422}\x{41e}\x{41b}\x{41f}\x{41e}\x{419}]: /url
",
             'html' => "<p><a href=\"/url\">\x{422}\x{43e}\x{43b}\x{43f}\x{43e}\x{439}</a> is a Russian word.</p>
"
           },
           {
             'markdown' => '[Foo
  bar]: /url

[Baz][Foo bar]
',
             'html' => '<p><a href="/url">Baz</a></p>
'
           },
           {
             'markdown' => '[foo] [bar]

[bar]: /url "title"
',
             'html' => '<p><a href="/url" title="title">foo</a></p>
'
           },
           {
             'markdown' => '[foo]
[bar]

[bar]: /url "title"
',
             'html' => '<p><a href="/url" title="title">foo</a></p>
'
           },
           {
             'markdown' => '[foo]: /url1

[foo]: /url2

[bar][foo]
',
             'html' => '<p><a href="/url1">bar</a></p>
'
           },
           {
             'markdown' => '[bar][foo\\!]

[foo!]: /url
',
             'html' => '<p>[bar][foo!]</p>
'
           },
           {
             'markdown' => '[foo][ref[]

[ref[]: /uri
',
             'html' => '<p>[foo][ref[]</p>
<p>[ref[]: /uri</p>
'
           },
           {
             'markdown' => '[foo][ref[bar]]

[ref[bar]]: /uri
',
             'html' => '<p>[foo][ref[bar]]</p>
<p>[ref[bar]]: /uri</p>
'
           },
           {
             'markdown' => '[[[foo]]]

[[[foo]]]: /url
',
             'html' => '<p>[[[foo]]]</p>
<p>[[[foo]]]: /url</p>
'
           },
           {
             'markdown' => '[foo][ref\\[]

[ref\\[]: /uri
',
             'html' => '<p><a href="/uri">foo</a></p>
'
           },
           {
             'markdown' => '[foo][]

[foo]: /url "title"
',
             'html' => '<p><a href="/url" title="title">foo</a></p>
'
           },
           {
             'markdown' => '[*foo* bar][]

[*foo* bar]: /url "title"
',
             'html' => '<p><a href="/url" title="title"><em>foo</em> bar</a></p>
'
           },
           {
             'markdown' => '[Foo][]

[foo]: /url "title"
',
             'html' => '<p><a href="/url" title="title">Foo</a></p>
'
           },
           {
             'markdown' => '[foo] 
[]

[foo]: /url "title"
',
             'html' => '<p><a href="/url" title="title">foo</a></p>
'
           },
           {
             'markdown' => '[foo]

[foo]: /url "title"
',
             'html' => '<p><a href="/url" title="title">foo</a></p>
'
           },
           {
             'markdown' => '[*foo* bar]

[*foo* bar]: /url "title"
',
             'html' => '<p><a href="/url" title="title"><em>foo</em> bar</a></p>
'
           },
           {
             'markdown' => '[[*foo* bar]]

[*foo* bar]: /url "title"
',
             'html' => '<p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>
'
           },
           {
             'markdown' => '[Foo]

[foo]: /url "title"
',
             'html' => '<p><a href="/url" title="title">Foo</a></p>
'
           },
           {
             'markdown' => '[foo] bar

[foo]: /url
',
             'html' => '<p><a href="/url">foo</a> bar</p>
'
           },
           {
             'markdown' => '\\[foo]

[foo]: /url "title"
',
             'html' => '<p>[foo]</p>
'
           },
           {
             'markdown' => '[foo*]: /url

*[foo*]
',
             'html' => '<p>*<a href="/url">foo*</a></p>
'
           },
           {
             'markdown' => '[foo`]: /url

[foo`]`
',
             'html' => '<p>[foo<code>]</code></p>
'
           },
           {
             'markdown' => '[foo][bar]

[foo]: /url1
[bar]: /url2
',
             'html' => '<p><a href="/url2">foo</a></p>
'
           },
           {
             'markdown' => '[foo][bar][baz]

[baz]: /url
',
             'html' => '<p>[foo]<a href="/url">bar</a></p>
'
           },
           {
             'markdown' => '[foo][bar][baz]

[baz]: /url1
[bar]: /url2
',
             'html' => '<p><a href="/url2">foo</a><a href="/url1">baz</a></p>
'
           },
           {
             'markdown' => '[foo][bar][baz]

[baz]: /url1
[foo]: /url2
',
             'html' => '<p>[foo]<a href="/url1">bar</a></p>
'
           },
           {
             'markdown' => '![foo](/url "title")
',
             'html' => '<p><img src="/url" alt="foo" title="title" /></p>
'
           },
           {
             'markdown' => '![foo *bar*]

[foo *bar*]: train.jpg "train & tracks"
',
             'html' => '<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
'
           },
           {
             'markdown' => '![foo ![bar](/url)](/url2)
',
             'html' => '<p><img src="/url2" alt="foo bar" /></p>
'
           },
           {
             'markdown' => '![foo [bar](/url)](/url2)
',
             'html' => '<p><img src="/url2" alt="foo bar" /></p>
'
           },
           {
             'markdown' => '![foo *bar*][]

[foo *bar*]: train.jpg "train & tracks"
',
             'html' => '<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
'
           },
           {
             'markdown' => '![foo *bar*][foobar]

[FOOBAR]: train.jpg "train & tracks"
',
             'html' => '<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
'
           },
           {
             'markdown' => '![foo](train.jpg)
',
             'html' => '<p><img src="train.jpg" alt="foo" /></p>
'
           },
           {
             'markdown' => 'My ![foo bar](/path/to/train.jpg  "title"   )
',
             'html' => '<p>My <img src="/path/to/train.jpg" alt="foo bar" title="title" /></p>
'
           },
           {
             'markdown' => '![foo](<url>)
',
             'html' => '<p><img src="url" alt="foo" /></p>
'
           },
           {
             'markdown' => '![](/url)
',
             'html' => '<p><img src="/url" alt="" /></p>
'
           },
           {
             'markdown' => '![foo] [bar]

[bar]: /url
',
             'html' => '<p><img src="/url" alt="foo" /></p>
'
           },
           {
             'markdown' => '![foo] [bar]

[BAR]: /url
',
             'html' => '<p><img src="/url" alt="foo" /></p>
'
           },
           {
             'markdown' => '![foo][]

[foo]: /url "title"
',
             'html' => '<p><img src="/url" alt="foo" title="title" /></p>
'
           },
           {
             'markdown' => '![*foo* bar][]

[*foo* bar]: /url "title"
',
             'html' => '<p><img src="/url" alt="foo bar" title="title" /></p>
'
           },
           {
             'markdown' => '![Foo][]

[foo]: /url "title"
',
             'html' => '<p><img src="/url" alt="Foo" title="title" /></p>
'
           },
           {
             'markdown' => '![foo] 
[]

[foo]: /url "title"
',
             'html' => '<p><img src="/url" alt="foo" title="title" /></p>
'
           },
           {
             'markdown' => '![foo]

[foo]: /url "title"
',
             'html' => '<p><img src="/url" alt="foo" title="title" /></p>
'
           },
           {
             'markdown' => '![*foo* bar]

[*foo* bar]: /url "title"
',
             'html' => '<p><img src="/url" alt="foo bar" title="title" /></p>
'
           },
           {
             'markdown' => '![[foo]]

[[foo]]: /url "title"
',
             'html' => '<p>![[foo]]</p>
<p>[[foo]]: /url &quot;title&quot;</p>
'
           },
           {
             'markdown' => '![Foo]

[foo]: /url "title"
',
             'html' => '<p><img src="/url" alt="Foo" title="title" /></p>
'
           },
           {
             'markdown' => '\\!\\[foo]

[foo]: /url "title"
',
             'html' => '<p>![foo]</p>
'
           },
           {
             'markdown' => '\\![foo]

[foo]: /url "title"
',
             'html' => '<p>!<a href="/url" title="title">foo</a></p>
'
           },
           {
             'markdown' => '<http://foo.bar.baz>
',
             'html' => '<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>
'
           },
           {
             'markdown' => '<http://foo.bar.baz?q=hello&id=22&boolean>
',
             'html' => '<p><a href="http://foo.bar.baz?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz?q=hello&amp;id=22&amp;boolean</a></p>
'
           },
           {
             'markdown' => '<irc://foo.bar:2233/baz>
',
             'html' => '<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>
'
           },
           {
             'markdown' => '<MAILTO:FOO@BAR.BAZ>
',
             'html' => '<p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>
'
           },
           {
             'markdown' => '<http://foo.bar/baz bim>
',
             'html' => '<p>&lt;http://foo.bar/baz bim&gt;</p>
'
           },
           {
             'markdown' => '<foo@bar.example.com>
',
             'html' => '<p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>
'
           },
           {
             'markdown' => '<foo+special@Bar.baz-bar0.com>
',
             'html' => '<p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>
'
           },
           {
             'markdown' => '<>
',
             'html' => '<p>&lt;&gt;</p>
'
           },
           {
             'markdown' => '<heck://bing.bong>
',
             'html' => '<p>&lt;heck://bing.bong&gt;</p>
'
           },
           {
             'markdown' => '< http://foo.bar >
',
             'html' => '<p>&lt; http://foo.bar &gt;</p>
'
           },
           {
             'markdown' => '<foo.bar.baz>
',
             'html' => '<p>&lt;foo.bar.baz&gt;</p>
'
           },
           {
             'markdown' => '<localhost:5001/foo>
',
             'html' => '<p>&lt;localhost:5001/foo&gt;</p>
'
           },
           {
             'markdown' => 'http://example.com
',
             'html' => '<p>http://example.com</p>
'
           },
           {
             'markdown' => 'foo@bar.example.com
',
             'html' => '<p>foo@bar.example.com</p>
'
           },
           {
             'markdown' => '<a><bab><c2c>
',
             'html' => '<p><a><bab><c2c></p>
'
           },
           {
             'markdown' => '<a/><b2/>
',
             'html' => '<p><a/><b2/></p>
'
           },
           {
             'markdown' => '<a  /><b2
data="foo" >
',
             'html' => '<p><a  /><b2
data="foo" ></p>
'
           },
           {
             'markdown' => '<a foo="bar" bam = \'baz <em>"</em>\'
_boolean zoop:33=zoop:33 />
',
             'html' => '<p><a foo="bar" bam = \'baz <em>"</em>\'
_boolean zoop:33=zoop:33 /></p>
'
           },
           {
             'markdown' => '<33> <__>
',
             'html' => '<p>&lt;33&gt; &lt;__&gt;</p>
'
           },
           {
             'markdown' => '<a h*#ref="hi">
',
             'html' => '<p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>
'
           },
           {
             'markdown' => '<a href="hi\'> <a href=hi\'>
',
             'html' => '<p>&lt;a href=&quot;hi\'&gt; &lt;a href=hi\'&gt;</p>
'
           },
           {
             'markdown' => '< a><
foo><bar/ >
',
             'html' => '<p>&lt; a&gt;&lt;
foo&gt;&lt;bar/ &gt;</p>
'
           },
           {
             'markdown' => '<a href=\'bar\'title=title>
',
             'html' => '<p>&lt;a href=\'bar\'title=title&gt;</p>
'
           },
           {
             'markdown' => '</a>
</foo >
',
             'html' => '<p></a>
</foo ></p>
'
           },
           {
             'markdown' => '</a href="foo">
',
             'html' => '<p>&lt;/a href=&quot;foo&quot;&gt;</p>
'
           },
           {
             'markdown' => 'foo <!-- this is a
comment - with hyphen -->
',
             'html' => '<p>foo <!-- this is a
comment - with hyphen --></p>
'
           },
           {
             'markdown' => 'foo <!-- not a comment -- two hyphens -->
',
             'html' => '<p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>
'
           },
           {
             'markdown' => 'foo <!--> foo -->

foo <!-- foo--->
',
             'html' => '<p>foo &lt;!--&gt; foo --&gt;</p>
<p>foo &lt;!-- foo---&gt;</p>
'
           },
           {
             'markdown' => 'foo <?php echo $a; ?>
',
             'html' => '<p>foo <?php echo $a; ?></p>
'
           },
           {
             'markdown' => 'foo <!ELEMENT br EMPTY>
',
             'html' => '<p>foo <!ELEMENT br EMPTY></p>
'
           },
           {
             'markdown' => 'foo <![CDATA[>&<]]>
',
             'html' => '<p>foo <![CDATA[>&<]]></p>
'
           },
           {
             'markdown' => '<a href="&ouml;">
',
             'html' => '<p><a href="&ouml;"></p>
'
           },
           {
             'markdown' => '<a href="\\*">
',
             'html' => '<p><a href="\\*"></p>
'
           },
           {
             'markdown' => '<a href="\\"">
',
             'html' => '<p>&lt;a href=&quot;&quot;&quot;&gt;</p>
'
           },
           {
             'markdown' => 'foo  
baz
',
             'html' => '<p>foo<br />
baz</p>
'
           },
           {
             'markdown' => 'foo\\
baz
',
             'html' => '<p>foo<br />
baz</p>
'
           },
           {
             'markdown' => 'foo       
baz
',
             'html' => '<p>foo<br />
baz</p>
'
           },
           {
             'markdown' => 'foo  
     bar
',
             'html' => '<p>foo<br />
bar</p>
'
           },
           {
             'markdown' => 'foo\\
     bar
',
             'html' => '<p>foo<br />
bar</p>
'
           },
           {
             'markdown' => '*foo  
bar*
',
             'html' => '<p><em>foo<br />
bar</em></p>
'
           },
           {
             'markdown' => '*foo\\
bar*
',
             'html' => '<p><em>foo<br />
bar</em></p>
'
           },
           {
             'markdown' => '`code  
span`
',
             'html' => '<p><code>code span</code></p>
'
           },
           {
             'markdown' => '`code\\
span`
',
             'html' => '<p><code>code\\ span</code></p>
'
           },
           {
             'markdown' => '<a href="foo  
bar">
',
             'html' => '<p><a href="foo  
bar"></p>
'
           },
           {
             'markdown' => '<a href="foo\\
bar">
',
             'html' => '<p><a href="foo\\
bar"></p>
'
           },
           {
             'markdown' => 'foo\\
',
             'html' => '<p>foo\\</p>
'
           },
           {
             'markdown' => 'foo
',
             'html' => '<p>foo</p>
'
           },
           {
             'markdown' => '### foo\\
',
             'html' => '<h3>foo\\</h3>
'
           },
           {
             'markdown' => '### foo
',
             'html' => '<h3>foo</h3>
'
           },
           {
             'markdown' => 'foo
baz
',
             'html' => '<p>foo
baz</p>
'
           },
           {
             'markdown' => 'foo 
 baz
',
             'html' => '<p>foo
baz</p>
'
           },
           {
             'markdown' => 'hello $.;\'there
',
             'html' => '<p>hello $.;\'there</p>
'
           },
           {
             'markdown' => "Foo \x{3c7}\x{3c1}\x{1fc6}\x{3bd}
",
             'html' => "<p>Foo \x{3c7}\x{3c1}\x{1fc6}\x{3bd}</p>
"
           },
           {
             'markdown' => 'Multiple     spaces
',
             'html' => '<p>Multiple     spaces</p>
'
           }
         ];
return $tests; } 1;