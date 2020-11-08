require "uri"
require "net/http"
require "JSON"

def request(url_api, key_api)
    url_api_key=url_api + "&api_key=" + key_api
    url = URI(url_api_key)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    JSON.parse(response.body)
end

def build_web_page(hash_input)
    photos=[]
    hash_input['photos'].each do |hash|
        photos.push(hash['img_src'])
    end

    name=[]
    hash_input['photos'].each do |hash|
        name.push(hash['camera']['full_name'])
    end

    date=[]
    hash_input['photos'].each do |hash|
        date.push(hash['earth_date'])
    end
    
    html_file=''

    #creamos la estructura del html
    #header
    html_file+="<!DOCTYPE html>\n"
    html_file+="<html lang='es'>\n"
    html_file+="</head>\n"
    html_file+="\t<meta charset='UTF-8'>\n"
    html_file+="\t<meta name='viewport' content='width=device-width, initial-scale=1.0'>\n"
    html_file+="\t<title>NASA</title>\n"
    html_file+="\t<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css' integrity='sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2' crossorigin='anonymous'>\n"

    html_file+="\t<script src='https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js' integrity='sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx' crossorigin='anonymous'></script>\n"
    html_file+="\t<link href='https://fonts.googleapis.com/css2?family=Cabin:wght@400;700&family=Lobster&display=swap' rel='stylesheet'>\n"
    html_file+="\t<link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.6.3/css/all.css' integrity='sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/' crossorigin='anonymous'>\n"
    html_file+="\t<link rel='stylesheet' href='assets/css/style.css'>\n"
    html_file+="</head>\n"

    #body
    html_file+="<body>\n"
    html_file+="\t<nav class='navbar navbar-expand-lg navbar-dark bg-dark fixed-top'>\n"
    html_file+="\t\t<div class='container'>\n"
    html_file+="\t\t<h2 class='texto_navbar_logo text-white mb-2'>NASA: FOTOS DE ROVERS</h2>\n"
    html_file+="\t</nav>\n"

    html_file+="\t<section class='container mt-5 pt-5'>\n"
    html_file+="\t\t<div class='row row-cols-1 row-cols-md-3'>\n"

    i=0
    photos.each do |photo|
       i+=1  
       html_file+="\t\t\t<div class='col mb-4'>\n"
       html_file+="\t\t\t<div class='card'>\n"
       html_file+="\t\t\t\t<img src="+photo+ " class='card-img-top' alt='...'>\n"
       html_file+="\t\t\t\t<div class='card-body'>\n"
       html_file+="\t\t\t\t\t<h5 class='card-title'>"+date[i-1].to_s+":"+name[i-1].to_s+"</h5>\n"
       html_file+="\t\t\t</div>\n"
       html_file+="\t\t\t</div>\n"
       html_file+="\t\t</div>\n"
    end

    html_file+="</div>\n"
        
    html_file+="</section>\n"
    html_file+="</body>\n"
    html_file+="</html>\n"

    File.write('pagina_web_fotos_nasa.html', html_file)
end


#hacemos el request con una URL y Credenciales
data=request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000' , 'vmP5575W9ABybKqMUyptITcTWOJdmd5cQZBLQq6y')

# Construimos la pagina web
build_web_page(data)


   