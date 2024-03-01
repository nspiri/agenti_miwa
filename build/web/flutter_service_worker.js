'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "2083bc5a5a95b1466e81ad8bdf932d04",
"assets/AssetManifest.json": "0f969013fd893a787183c51ba05c207d",
"assets/assets/data/cart_data.json": "940fb962d37af7d489bdaa0cf3a1d64a",
"assets/assets/data/chat_data.json": "5398c3169ea3f3908ac21cccc49516e3",
"assets/assets/data/clienti.json": "ad2ab394dc4f64148c448f78bb8bf158",
"assets/assets/data/comuni.json": "d5089af2fb427b702a3e28ff2cbeac72",
"assets/assets/data/customers_list.json": "5fdbe70bff7637f7de9544ad569cbdf8",
"assets/assets/data/nazionalita.json": "686898ef92176d2963518a57bbb6b4fd",
"assets/assets/data/order_detail.json": "0257d856fe5dc5b40801411f632deb15",
"assets/assets/data/order_list.json": "77e843dd9995264fe24d4fad34ed16f0",
"assets/assets/data/paesi.json": "2c2d3f0eac54f9c05a5a56207132f86a",
"assets/assets/data/products_list.json": "b4f8b518ef3b8c163901ec36777cdc95",
"assets/assets/data/product_data.json": "11fff213923109bbeac467f4dbdd3a9f",
"assets/assets/data/restaurant_data.json": "852eb2c1594cb9b5e05d09cc99830662",
"assets/assets/data/tipo_soc.json": "8812149a5818c6556b364a3e908cad31",
"assets/assets/data/wallet.json": "89142c73daa0b596b52ff49c801511dc",
"assets/assets/images/dummy/auth_side_image.png": "dc17e44901d40883f85df66ba7682e4d",
"assets/assets/images/dummy/avatar_1.png": "f7de3bd663dc8adee416a9e18f8e2903",
"assets/assets/images/dummy/avatar_10.png": "0ef9d344a13ef06dc58655fce4c8f6b3",
"assets/assets/images/dummy/avatar_11.png": "89209752f5ee7adb398273a98711a729",
"assets/assets/images/dummy/avatar_12.png": "2bec42fcd3af7ac63b7a3571bd652af3",
"assets/assets/images/dummy/avatar_13.png": "b5b3bc26058d2d6d0eeb1e9b9161d7f8",
"assets/assets/images/dummy/avatar_14.png": "b50d7fcc47419aa01655db8376c7a788",
"assets/assets/images/dummy/avatar_15.png": "3d115de7d52045cab48a614f645353d3",
"assets/assets/images/dummy/avatar_16.png": "fbc7601618c61d3e38b762fba8da73be",
"assets/assets/images/dummy/avatar_17.png": "7429fe6c55b068ce4c872e577ed3c0b0",
"assets/assets/images/dummy/avatar_18.png": "a894f31accd40521d87a3f32e67d217b",
"assets/assets/images/dummy/avatar_19.png": "8254fb00b181ebd76410fb0d12d5698b",
"assets/assets/images/dummy/avatar_2.png": "7f1ab3a3fd82847df2c3f7d0e16a6aca",
"assets/assets/images/dummy/avatar_20.png": "d02ab3373dc567f376eee0b3893eedbd",
"assets/assets/images/dummy/avatar_21.png": "601ef1c91636276a28853f25abc16eec",
"assets/assets/images/dummy/avatar_22.png": "8e3b3d9f8859caf532cde3acaa3dc8af",
"assets/assets/images/dummy/avatar_23.png": "ed9d32ce914a1757c8c02d301a586cc4",
"assets/assets/images/dummy/avatar_24.png": "c7f17927f516a938d56fce4f76ce6195",
"assets/assets/images/dummy/avatar_25.png": "321080231eb752870cbb2a51af9ee9b5",
"assets/assets/images/dummy/avatar_26.png": "1a82ad49068403c4eacc883b32533107",
"assets/assets/images/dummy/avatar_27.png": "dfbe736f03b055f8ffc20d5ec4ab95bb",
"assets/assets/images/dummy/avatar_28.png": "0814785dc9146fccca0ba3bb1f15989b",
"assets/assets/images/dummy/avatar_29.png": "49918e780f79f91b8da6e803ee24cb63",
"assets/assets/images/dummy/avatar_3.png": "d06518cd5cedc083daf562680ccfa93c",
"assets/assets/images/dummy/avatar_30.png": "7d06964293d5eab81f1e160ed3a0de34",
"assets/assets/images/dummy/avatar_4.png": "cf3ae050ad74605ccd896c83b8f46ff5",
"assets/assets/images/dummy/avatar_5.png": "d99ecaba6b42d90af152f2addf08da09",
"assets/assets/images/dummy/avatar_6.png": "dde24a5451eeda582586c5c40e80fdb5",
"assets/assets/images/dummy/avatar_7.png": "f4c495bbddb89d9f6d96165eeb36659b",
"assets/assets/images/dummy/avatar_8.png": "584e2073cb289f85e4cf3f7d27e784c3",
"assets/assets/images/dummy/avatar_9.png": "cfdc76bbabbe62e555395d65d72192b3",
"assets/assets/images/dummy/background.jpg": "e9f25f9e9daf2e355e7c44b5877c46ba",
"assets/assets/images/fast_food/baklava.png": "1bfc29a1f52153ac88583c866760b766",
"assets/assets/images/fast_food/barbecue.png": "cc4539ed31d3b1596c505e51905b8aeb",
"assets/assets/images/fast_food/burger.png": "0f8bb03b243148a1dc3675fd2a7d5ffe",
"assets/assets/images/fast_food/cake.png": "8ba2702da6fa6b9209e4c19c628219a9",
"assets/assets/images/fast_food/chicken-leg.png": "32a3a554ccb37dd9262feb8f375252f1",
"assets/assets/images/fast_food/coffee.png": "12d00c03dc43f3e6e79843695c69ce16",
"assets/assets/images/fast_food/cupcake.png": "d56699c94496fda3ec79bb00938c37a9",
"assets/assets/images/fast_food/delivery_boy.png": "5ffddd949729eaf9e0a5250036e45141",
"assets/assets/images/fast_food/doughnut.png": "f2a56c849033d88b8f021f24e245352d",
"assets/assets/images/fast_food/food.png": "e85035ae4a31a22f34844e3ce727bca2",
"assets/assets/images/fast_food/hamburger.png": "cb77278941cee4a37dc559316082d6f5",
"assets/assets/images/fast_food/masala-dosa.png": "90bfe7c3a9b7159ce8da373ec5d648b5",
"assets/assets/images/fast_food/nachos.png": "ad9ef5f73a7c9fb3c9f0ea14ccc5525a",
"assets/assets/images/fast_food/noodles.png": "ec152b5988227d63c9aa6154d8f3045a",
"assets/assets/images/fast_food/pizza.png": "377f9fff7889adfa30d4d27d5a32b4e4",
"assets/assets/images/fast_food/salad.png": "e439abc4ee4e8798d52354265bf97a21",
"assets/assets/images/food/burger_king.png": "d385fc89757f10a364c08e308b35e056",
"assets/assets/images/food/carrows.png": "c1ef5e528caffb602eaf30f9fc9311a6",
"assets/assets/images/food/domino's.png": "dbcf21f3af42a882ae3061c50349be14",
"assets/assets/images/food/food-1.png": "a0557fb561bde0bb63e3a91c44a068a1",
"assets/assets/images/food/food-2.png": "b99096c602ee43242e17a03c3e83bf26",
"assets/assets/images/food/food-3.png": "0b82167108b6d80d10d806e9ed4f01c3",
"assets/assets/images/food/food_offer_1.png": "37adc1fcd633645d4509518afd760ab7",
"assets/assets/images/food/food_offer_2.png": "22064a8a6a99bba8bec057188ae123e0",
"assets/assets/images/food/kfc.png": "b8c6f2dc9b7cd42b0620bb6d60746461",
"assets/assets/images/food/mc_donald's.png": "2e20cccab9e36231e357b3e8d119424c",
"assets/assets/images/food/no_image.jpg": "5bb2388e88145429c9baabf34861b8dc",
"assets/assets/images/food/pizza_hut.png": "e9173d0e6f71e443b1134af8a4d5c756",
"assets/assets/images/restaurant_logo/restaurant_logo_1.png": "55e851f80324d24920536c3ee49df049",
"assets/assets/images/restaurant_logo/restaurant_logo_10.png": "e53f8c3351af02cebf84d3d8428c9ed9",
"assets/assets/images/restaurant_logo/restaurant_logo_11.png": "a8040ad380f96363b4f6e4c8e0dc9fd2",
"assets/assets/images/restaurant_logo/restaurant_logo_2.png": "21a0482428f1c582315372974a69a7de",
"assets/assets/images/restaurant_logo/restaurant_logo_3.png": "9088ef7ff192f177a51c8e8e1d87df57",
"assets/assets/images/restaurant_logo/restaurant_logo_4.png": "644ae60f52b2e810f85d176e3e2637c4",
"assets/assets/images/restaurant_logo/restaurant_logo_5.png": "9407ad7b51d4aea59689b545fb13d83d",
"assets/assets/images/restaurant_logo/restaurant_logo_6.png": "f989892ca386f607800b2dda45381220",
"assets/assets/images/restaurant_logo/restaurant_logo_7.png": "c313d9386ee2c12af7dff077c637299c",
"assets/assets/images/restaurant_logo/restaurant_logo_8.png": "c3d1ba9b33605f5a401faf3fd52fd36b",
"assets/assets/images/restaurant_logo/restaurant_logo_9.png": "28f1a4c23af63dc0841ef8845e6b71d9",
"assets/assets/lang/ar.jpg": "9143f6bb9f70a7082b2d49a2fa2b0339",
"assets/assets/lang/ar.json": "6e772c89432019cc901e28404b85559f",
"assets/assets/lang/en.jpg": "6dd96569bff0a5c5ada7d99222b9815d",
"assets/assets/lang/en.json": "ab6875cb360d40776e89dc3dfc2cf4b4",
"assets/assets/lang/es.jpg": "25d67fb418ce2623d770679b2fd4f575",
"assets/assets/lang/es.json": "d4f1619a23b6be7ec06383ab2affd4a2",
"assets/assets/lang/fr.jpg": "ed28420a8f74b0631c24659a40511c2d",
"assets/assets/lang/fr.json": "b3636aca89944180d4033fded7e35081",
"assets/assets/lang/hi.jpg": "806b19b66156a2bfcb232d4f6518747a",
"assets/assets/lang/hi.json": "e1f53fd0d994711b95ef1acaffc89204",
"assets/assets/logo/foodLogo.png": "52133fc7e87b86c0b528d41f4e5bfdb5",
"assets/FontManifest.json": "1ee00d31df7d0b30bfafc1cf4922abf8",
"assets/fonts/MaterialIcons-Regular.otf": "ed81df14894dc012f2f7c24d7ef96c31",
"assets/NOTICES": "47ad3007f3bebd465d24b60c22d4f2c6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/lucide_icons/assets/lucide.ttf": "03f254a55085ec6fe9a7ae1861fda9fd",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"canvaskit/canvaskit.js": "bbf39143dfd758d8d847453b120c8ebb",
"canvaskit/canvaskit.wasm": "42df12e09ecc0d5a4a34a69d7ee44314",
"canvaskit/chromium/canvaskit.js": "96ae916cd2d1b7320fff853ee22aebb0",
"canvaskit/chromium/canvaskit.wasm": "be0e3b33510f5b7b0cc76cc4d3e50048",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "1a074e8452fe5e0d02b112e22cdcf455",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "6b515e434cea20006b3ef1726d2c8894",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"img/splash.jpg": "8a78392f13c17f6ed3dd25806739bb40",
"img/splash.png": "52133fc7e87b86c0b528d41f4e5bfdb5",
"index.html": "4da86feacbaa69172a8754e4d34825c2",
"/": "4da86feacbaa69172a8754e4d34825c2",
"main.dart.js": "126ecc9fea77ed896a822e7ecdb8b483",
"manifest.json": "70a511e80e66db4e89ea9ffca5207b03",
"version.json": "306b0615cdcdccd2e0af45c583b56938"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
