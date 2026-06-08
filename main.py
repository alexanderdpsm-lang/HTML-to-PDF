import os
import io
import pdfkit
from fastapi import FastAPI, HTTPException, Body
from fastapi.responses import StreamingResponse

app = FastAPI(title="HTML to PDF Converter Service")

# Si está en Windows usa la ruta local, si está en Linux (Docker) usa la ruta por defecto
if os.name == 'nt':
    path_wkhtmltopdf = r'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe'
    config = pdfkit.configuration(wkhtmltopdf=path_wkhtmltopdf)
else:
    # En Linux/Docker ya está en el PATH del sistema automáticamente
    config = pdfkit.configuration()

@app.post("/convert")
async def convert_html_to_pdf(html_content: str = Body(..., embed=True)):
    if not html_content.strip():
        raise HTTPException(status_code=400, detail="El contenido HTML está vacío.")
    
    try:
        pdf_bytes = pdfkit.from_string(html_content, False, configuration=config)
        pdf_buffer = io.BytesIO(pdf_bytes)
        
        return StreamingResponse(
            pdf_buffer,
            media_type="application/pdf",
            headers={"Content-Disposition": "attachment; filename=documento.pdf"}
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error en la conversión: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)