$pdf_mode = 5;

# The project class uses fontspec and Russian Unicode text, so the default
# engine is XeLaTeX. Switch to lualatex here if local font caches are configured.
$xelatex = 'xelatex -interaction=nonstopmode -halt-on-error -file-line-error %O %S';

$bibtex = 'bibtex %O %B';
$biber = 'biber %O %B';

$aux_dir = 'build';
$out_dir = 'build';

$pdf_previewer = 'true';
$new_viewer_always = 0;

@default_files = ('main.tex');
