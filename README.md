# minecraft_mmccoo docker example
Minecraft Bedrock Edition

Using docker to install [minecraft_mmccoo](https://github.com/mmccoo/minecraft_mmccoo) with an example website. 

# Usage
Build the images.

    docker-compose build
    
Run basic_test on the example world database

    docker-compose run --rm minecraft_mmccoo /home/minecraft_mmccoo/basic_test --db_path /home/db
    
Run server listening on port 80

    docker-compose up -d
    
Open http://localhost in browser

# Access the container shell
The following command provides shell access on the container:

    docker-compose run --rm minecraft_mmccoo bash
    
# Bedrock Minecraft World db
If you want to run the example on your own local minecraft world db files, simply change the following line in the docker-compose.yml file:

    volumes: 
        - ./world/db:/home/db
        ...

To

    volumes: 
        - <path to db folder>:/home/db
        ...
