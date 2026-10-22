<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.List, com.tap.model.Restaurant" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>FlavorFleet | Order Food Online from Top Restaurants</title>

            <!-- Favicon & App Icons -->
            <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">
            <link rel="shortcut icon" type="image/png"
                href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">

            <!-- Master Common External Stylesheet -->
            <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
        </head>

        <body>

            <!-- Unified Reusable Navbar Component -->
            <jsp:include page="navbar.jsp" />

            <!-- Split Hero with Food Carousel -->
            <section class="hero">
                <div class="hero-inner">
                    <div class="hero-content">
                        <div class="hero-badge">
                            <span>&#128293;</span> Top Dining Spots Delivering Near You
                        </div>
                        <h1>Craving delicious food?<br>Order from <span>top restaurants</span></h1>
                        <p>Explore handcrafted regional delicacies, authentic aromas, and fast express deliveries across
                            Bengaluru.</p>

                        <!-- Search Bar -->
                        <div class="search-bar-clay">
                            <span style="font-size:17px;color:#a8a29e;margin-right:10px;">&#128269;</span>
                            <input type="text" id="restaurantSearchInput"
                                placeholder="Search restaurants, cuisines, dishes..." onkeyup="filterRestaurants()">
                            <button class="clay-btn clay-btn-primary" type="button" onclick="filterRestaurants()"
                                style="padding:8px 18px;border-radius:12px;">Explore</button>
                        </div>
                    </div>

                    <!-- Carousel -->
                    <div style="display:flex;justify-content:center;">
                        <div class="carousel-card" id="heroCarousel">
                            <div class="carousel-track">
                                <div class="carousel-slide active">
                                    <img src="<%= request.getContextPath() %>/images/restaurants/chicken-biryani.jpg"
                                        alt="Royal Biryani"
                                        onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">
                                    <div class="carousel-overlay">
                                        <span class="carousel-tag">&#128293; Royal Biryani</span>
                                        <div>
                                            <h3 class="carousel-title">Dum Biryani Special</h3>
                                            <p class="carousel-desc">Aromatic long-grain basmati cooked with authentic
                                                spices</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="carousel-slide">
                                    <img src="<%= request.getContextPath() %>/images/restaurants/masala-dosa.jpg"
                                        alt="Crispy Dosa"
                                        onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">
                                    <div class="carousel-overlay">
                                        <span class="carousel-tag">&#9889; South Indian Classic</span>
                                        <div>
                                            <h3 class="carousel-title">Golden Crispy Dosa</h3>
                                            <p class="carousel-desc">Served hot with coconut chutney and rich lentil
                                                sambar</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="carousel-slide">
                                    <img src="<%= request.getContextPath() %>/images/restaurants/paneer-butter-masala.jpg"
                                        alt="Paneer Butter Masala"
                                        onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">
                                    <div class="carousel-overlay">
                                        <span class="carousel-tag">&#11088; North Indian Delight</span>
                                        <div>
                                            <h3 class="carousel-title">Paneer Butter Masala</h3>
                                            <p class="carousel-desc">Velvety butter gravy with soft cottage cheese &
                                                butter naan</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="carousel-slide">
                                    <img src="<%= request.getContextPath() %>/images/restaurants/tandoori-chicken.jpg"
                                        alt="Tandoori"
                                        onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">
                                    <div class="carousel-overlay">
                                        <span class="carousel-tag">&#127831; Clay-Oven Grills</span>
                                        <div>
                                            <h3 class="carousel-title">Smoky Tandoori Junction</h3>
                                            <p class="carousel-desc">Char-grilled tandoori delicacies with fresh mint
                                                chutney</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <button class="carousel-nav-btn carousel-prev" type="button"
                                onclick="prevSlide()">&#10094;</button>
                            <button class="carousel-nav-btn carousel-next" type="button"
                                onclick="nextSlide()">&#10095;</button>

                            <div class="carousel-dots" id="carouselDots">
                                <span class="carousel-dot active" onclick="goToSlide(0)"></span>
                                <span class="carousel-dot" onclick="goToSlide(1)"></span>
                                <span class="carousel-dot" onclick="goToSlide(2)"></span>
                                <span class="carousel-dot" onclick="goToSlide(3)"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Main Content -->
            <main class="main-container">

                <!-- Cuisine Filter Chips -->
                <div class="cuisine-scroll">
                    <button class="clay-chip active" onclick="selectCuisine(this, 'all')">All Cuisines</button>
                    <button class="clay-chip" onclick="selectCuisine(this, 'South Indian')">South Indian</button>
                    <button class="clay-chip" onclick="selectCuisine(this, 'Biryani')">Biryani</button>
                    <button class="clay-chip" onclick="selectCuisine(this, 'Punjabi')">Punjabi</button>
                    <button class="clay-chip" onclick="selectCuisine(this, 'North Indian')">North Indian</button>
                    <button class="clay-chip" onclick="selectCuisine(this, 'Thali')">Thali</button>
                    <button class="clay-chip" onclick="selectCuisine(this, 'Indo-Chinese')">Indo-Chinese</button>
                    <button class="clay-chip" onclick="selectCuisine(this, 'Kebab')">Kebabs</button>
                    <button class="clay-chip" onclick="selectCuisine(this, 'Sweets')">Desserts & Sweets</button>
                </div>

                <% List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
                        if (restaurants == null || restaurants.isEmpty()) {
                        %>
                        <div class="clay-card"
                            style="text-align:center;padding:50px 20px;max-width:500px;margin:30px auto;">
                            <div style="font-size:48px;margin-bottom:12px;">&#127869;</div>
                            <h2 style="font-size:20px;margin-bottom:8px;">No Restaurants Found</h2>
                            <p style="color:#78716c;font-size:14px;">Please check your database or try searching again
                                later.</p>
                        </div>
                        <% } else { %>
                            <div class="section-header" id="restaurant-section">
                                <div class="section-title">
                                    Restaurants Delivering Near You
                                    <span class="clay-badge clay-badge-orange" id="visibleCount">
                                        <%= restaurants.size() %> places
                                    </span>
                                </div>
                            </div>

                            <div class="restaurant-grid" id="restaurantGrid">
                                <% for (Restaurant restaurant : restaurants) { String
                                    imagePath=restaurant.getImagePath(); String cleanPath=(imagePath==null) ? "" :
                                    imagePath.replaceFirst("^/+", "" ); String imageUrl=request.getContextPath() + "/" +
                                    cleanPath; String name=(restaurant.getName()==null) ? "Restaurant" :
                                    restaurant.getName(); String cuisine=(restaurant.getCuisineType()==null)
                                    ? "Multi-Cuisine" : restaurant.getCuisineType(); String
                                    address=(restaurant.getAddress()==null) ? "Bengaluru" : restaurant.getAddress();
                                    double rating=restaurant.getRating(); int deliveryTime=restaurant.getDeliveryTime();
                                    boolean isActive=restaurant.isActive(); %>
                                    <a href="menu?restaurantId=<%= restaurant.getRestaurantId() %>"
                                        class="restaurant-clay-card" data-name="<%= name.toLowerCase() %>"
                                        data-cuisine="<%= cuisine.toLowerCase() %>">

                                        <div class="image-wrapper">
                                            <img class="restaurant-image" src="<%= imageUrl %>" alt="<%= name %>"
                                                loading="lazy"
                                                onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">

                                            <div class="delivery-pill">
                                                <span>&#9889;</span>
                                                <span>
                                                    <%= deliveryTime %>-<%= deliveryTime + 10 %> mins
                                                </span>
                                            </div>
                                        </div>

                                        <div class="card-content">
                                            <div class="card-header-row">
                                                <h3 class="restaurant-name">
                                                    <%= name %>
                                                </h3>
                                                <div class="rating-badge">
                                                    <span>&#9733;</span>
                                                    <span>
                                                        <%= String.format("%.1f", rating) %>
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="cuisine-type">
                                                <%= cuisine %>
                                            </div>

                                            <div class="card-footer-row">
                                                <div class="locality">
                                                    <span>&#128205;</span>
                                                    <span>
                                                        <%= address %>
                                                    </span>
                                                </div>
                                                <span class="clay-badge <%= isActive ? " clay-badge-green"
                                                    : "clay-badge-orange" %>">
                                                    <%= isActive ? "● Open" : "● Closed" %>
                                                </span>
                                            </div>
                                        </div>
                                    </a>
                                    <% } %>
                            </div>
                            <% } %>

            </main>

            <!-- Unified Reusable Footer Component -->
            <jsp:include page="footer.jsp" />

            <!-- Interactive Scripts: Carousel, Filter & Search -->
            <script>
                let currentSlide = 0;
                const slides = document.querySelectorAll('.carousel-slide');
                const dots = document.querySelectorAll('.carousel-dot');
                let carouselInterval;

                function showSlide(index) {
                    if (!slides.length) return;
                    if (index >= slides.length) currentSlide = 0;
                    else if (index < 0) currentSlide = slides.length - 1;
                    else currentSlide = index;

                    slides.forEach((slide, i) => {
                        slide.classList.toggle('active', i === currentSlide);
                    });
                    dots.forEach((dot, i) => {
                        dot.classList.toggle('active', i === currentSlide);
                    });
                }

                function nextSlide() { showSlide(currentSlide + 1); resetCarouselTimer(); }
                function prevSlide() { showSlide(currentSlide - 1); resetCarouselTimer(); }
                function goToSlide(i) { showSlide(i); resetCarouselTimer(); }

                function startCarouselTimer() {
                    carouselInterval = setInterval(() => { showSlide(currentSlide + 1); }, 3800);
                }
                function resetCarouselTimer() {
                    clearInterval(carouselInterval);
                    startCarouselTimer();
                }

                startCarouselTimer();

                // Search & Cuisine Filter
                let currentCuisineFilter = 'all';

                function selectCuisine(btn, cuisine) {
                    document.querySelectorAll('.clay-chip').forEach(b => b.classList.remove('active'));
                    btn.classList.add('active');
                    currentCuisineFilter = cuisine.toLowerCase();
                    filterRestaurants();
                }

                function filterRestaurants() {
                    const query = (document.getElementById('restaurantSearchInput').value || '').toLowerCase().trim();
                    const cards = document.querySelectorAll('.restaurant-clay-card');
                    let count = 0;

                    cards.forEach(card => {
                        const name = (card.getAttribute('data-name') || '');
                        const cuisine = (card.getAttribute('data-cuisine') || '');

                        const matchesQuery = !query || name.includes(query) || cuisine.includes(query);
                        const matchesCuisine = (currentCuisineFilter === 'all') || cuisine.includes(currentCuisineFilter);

                        if (matchesQuery && matchesCuisine) {
                            card.style.display = 'flex';
                            count++;
                        } else {
                            card.style.display = 'none';
                        }
                    });

                    const countElem = document.getElementById('visibleCount');
                    if (countElem) countElem.textContent = count + ' places';
                }
            </script>
        </body>

        </html>