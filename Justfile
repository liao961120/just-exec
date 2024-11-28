# checkexec [OPTIONS] <target> [dependencies]... -- <command>... \
pdf2png_exe := if os_family() == "windows" { "pdf2png.bat" } else { "pdf2png" }

# Compile all PNGs
default: pdf2png typ2png

# Compile PDF (1st page) to PNG
pdf2png: latex2pdf
    for fp in *.pdf; \
        do           \
            checkexec "${fp%.*}.png" "$fp" -- \
                {{ pdf2png_exe }} "$fp" --page=1 --dpi=350; \
        done

# Compile .tex to PDF
latex2pdf:
    for fp in *.tex; \
        do           \
            checkexec "${fp%.*}.pdf" "$fp" -- \
                tectonic -X compile "$fp"; \
        done

# Compile .typ to PNG
typ2png:
    for fp in *.typ; do \
        checkexec "${fp%.*}.png" "${fp}" -- \
            typst compile --ppi=350 "${fp}" "${fp%.*}.png"; \
    done
