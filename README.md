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
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
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
  * get all merchants `http://localhost:3000/api/v1/merchants`
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

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Leland Curtis - lelandcurtis88@gmail.com

Project Link: [https://github.com/LelandCurtis/rails-engine](https://github.com/LelandCurtis/rails-engine)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* []()
* []()
* []()

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/LelandCurtis/rails-engine.svg?style=for-the-badge
[contributors-url]: https://github.com/LelandCurtis/rails-engine/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/LelandCurtis/rails-engine.svg?style=for-the-badge
[forks-url]: https://github.com/LelandCurtis/rails-engine/network/members
[stars-shield]: https://img.shields.io/github/stars/LelandCurtis/rails-engine.svg?style=for-the-badge
[stars-url]: https://github.com/LelandCurtis/rails-engine/stargazers
[issues-shield]: https://img.shields.io/github/issues/LelandCurtis/rails-engine.svg?style=for-the-badge
[issues-url]: https://github.com/LelandCurtis/rails-engine/issues
[license-shield]: https://img.shields.io/github/license/LelandCurtis/rails-engine.svg?style=for-the-badge
[license-url]: https://github.com/LelandCurtis/rails-engine/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/leland-curtis-b9a13a2b
[product-screenshot]: images/screenshot.png
[database_schema]: https://user-images.githubusercontent.com/15107515/152901359-aadf9cd8-4350-4ce6-8bd3-332171d2bebf.png
