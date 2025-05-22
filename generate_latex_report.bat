@echo off
echo ========================================
echo Génération du rapport LaTeX
echo ========================================

cd latex

echo Première compilation (pdflatex)...
pdflatex -interaction=nonstopmode main.tex

echo Compilation de la bibliographie (bibtex)...
bibtex main

echo Deuxième compilation (pdflatex)...
pdflatex -interaction=nonstopmode main.tex

echo Troisième compilation (pdflatex)...
pdflatex -interaction=nonstopmode main.tex

echo.
echo ========================================
echo Terminé! Vérifiez le rapport dans:
echo - latex/main.pdf
echo ========================================
pause
