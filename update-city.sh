#!/bin/bash
sudo apt-get install -y httpie
http PUT http://localhost:3000/city?id=eq.1 <<<'{"id": 1, "name": "Gotham CIty", "countrycode": "USA", "district": "New Jersey", "population": 10000}'
