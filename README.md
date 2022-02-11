<h1 align="center">Rails Engine</h1>

  <p align="center">
    An E-Commerce Application API
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#api-endpoints">API Endpoints</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This E-Commerce application API provides users access to data about merchants, items, customers, invoices, and transactions. It is built using ruby on rails. It provides users access to the following endpoints:

#### Merchants:
  * get all merchants
  * get one merchant
  * get all items held by a given merchant
#### Items:
  * get all items
  * get one item
  * create an item
  * edit an item
  * delete an item
  * get the merchant data for a given item ID
#### Search:
  * find one item by name
  * find one item by minimum price and/or maximum price
  * find all merchants by name

#### Database Schema:
[![Database Schema][database_schema]](https://user-images.githubusercontent.com/15107515/152901359-aadf9cd8-4350-4ce6-8bd3-332171d2bebf.png)

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [Rails v5.2.6](https://rubyonrails.org/)
* [Ruby v2.7.2](https://www.ruby-lang.org/en/)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

### Installation

2. Clone the repo
   ```sh
   git clone https://github.com/LelandCurtis/rails-engine.git
   ```
3. Install Ruby 2.7.2 and Rails 5.2.6

3. Install required gems using the included gemfile
   ```sh
   bundle install
   ```
3. Create Postgresql database, run migrations and seed database
   ```sh
   rails db:{create,migrate,seed}
   ```
3. Launch local server
   ```sh
   rails s
   ```
3. Use a browser or tool like PostMan to explore the API on http://localhost:3000
   ```sh
   http://localhost:3000
   ```


<p align="right">(<a href="#top">back to top</a>)</p>

## API Endpoints

#### Merchants:
  * get all merchants `GET http://localhost:3000/api/v1/merchants`
  * get one merchant `GET http://localhost:3000/api/v1/merchants/:merchant_id`
  * get all items held by a given merchant `GET http://localhost:3000/api/v1/merchants/:merchant_id/items`
#### Items:
  * get all items `GET http://localhost:3000/api/v1/items`
  * get one item `GET http://localhost:3000/api/v1/items/:item_id`
  * create an item `POST http://localhost:3000/api/v1/items/:item_id`
  * edit an item `PUT http://localhost:3000/api/v1/items/:item_id`
  * delete an item `DESTROY http://localhost:3000/api/v1/items/:item_id`
  * get the merchant data for a given item ID `GET http://localhost:3000/api/v1/items/:item_id/merchant`
#### Search:
  * find one item by name `GET http://localhost:3000/api/v1/items/find?name=some_query`
  * find one item by minimum price and/or maximum price `GET http://localhost:3000/api/v1/items/find?min_price=5.00&max_price=500.00`
  * find all merchants by name `GET http://localhost:3000/api/v1/merchants/find_all?name=some_query`

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Leland Curtis - lelandcurtis88@gmail.com

Project Link: [https://github.com/LelandCurtis/rails-engine](https://github.com/LelandCurtis/rails-engine)

<p align="right">(<a href="#top">back to top</a>)</p>
