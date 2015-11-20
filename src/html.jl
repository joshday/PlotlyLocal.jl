const html_template = mt"""
<!DOCTYPE html>
<html>
<head>
  <script src = {{{:plotlysource}}}></script>
</head>

<body>
  <div id="div1">
  <script>
    var data = {{{:data}}}
    var layout = {{{:layout}}}
    Plotly.newPlot('div1', data, layout);
  </script>
</body>
</html>
"""
