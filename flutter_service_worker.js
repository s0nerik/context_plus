'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"CNAME": "02e1674c9e6dc4d9e12a876d583ece8f",
"main.dart.wasm": "5a8b973c3cc90791d1e06c1f75cfb2c1",
"icons/Icon-maskable-192.png": "d1da14f34e29939620c344bdff682cc7",
"icons/Icon-192.png": "42730ac22d2b8791cb089b198e99c363",
"icons/Icon-maskable-512.png": "1c3b3a232b8924d3de3807db7be445e6",
"icons/Icon-512.png": "af8d06d8d3445769a1ff18a4ccff298b",
"assets/fonts/MaterialIcons-Regular.otf": "ef0e4a5ed82b05e88a60ef80cdec8802",
"assets/AssetManifest.bin.json": "41747d3d13e39ea17299fccdd05f0ce0",
"assets/AssetManifest.bin": "673721150207002efac38c2edb12b657",
"assets/AssetManifest.json": "15a67633444f838fc1907dbe4529738c",
"assets/pubspec.yaml": "0803e07949c29adf4e6c01d077f7c0d3",
"assets/lib/examples/rainbow/variants/stateful_widget.dart": "7b86b3a59f9fbdf7d190abef83a92404",
"assets/lib/examples/rainbow/variants/context_plus.dart": "9eadd1ebb5ea0cdc02f53242fde3539e",
"assets/lib/examples/showcase/variants/pure_flutter.dart": "638b7ee12951a3f2b303424ca932f951",
"assets/lib/examples/showcase/variants/context_plus.dart": "2f3a54b221d978f39f92f26a6160183d",
"assets/lib/examples/derived_state/variants/context_plus_value_notifier_function.dart": "18f91030892e86b1e9a11c6ae066a7e2",
"assets/lib/examples/derived_state/variants/context_plus_change_notifier.dart": "6369bfee17e8df7186919aefa502ffe4",
"assets/lib/examples/counter/variants/stateful_widget.dart": "6d493eca3393db935eb2a1dd989d8ff4",
"assets/lib/examples/counter/variants/context_plus.dart": "8ca8fc6ad7ab6286b5cd01d60a7353f0",
"assets/lib/examples/country_search/variants/context_plus_state_2.dart": "3202eb37482ad73015bd9a320818d44d",
"assets/lib/examples/country_search/variants/stateful_widget.dart": "602a6cc42bf0df408af0d39ffae5bd06",
"assets/lib/examples/country_search/variants/stateful_and_inherited.dart": "a23fd131df110a8598c355131597266c",
"assets/lib/examples/country_search/variants/context_plus_state_1.dart": "b76af4e3f95d6552da0c9488d6b58ece",
"assets/lib/examples/country_search/variants/context_plus.dart": "08f160718bbdc96b19209889dfcfc35f",
"assets/lib/examples/country_search/util/countries.json": "967e6fcbee63510b3bf4a41ea78dbff8",
"assets/lib/examples/nested_scopes/variants/context_plus.dart": "6ae0ddb9c3bb834b7154ffbb423d828f",
"assets/lib/examples/counter_with_propagation/variants/stateful_widget_explicit_params.dart": "fd0ae41f0db5f860136b7ffc0948f9a9",
"assets/lib/examples/counter_with_propagation/variants/context_plus_bind_watch.dart": "5e9f390c4077cdb6a22de3ab5ccc4dfb",
"assets/lib/examples/counter_with_propagation/variants/context_plus_stateful_bind_value.dart": "159cd788d54d4dde827c8ccf7d0a8eb4",
"assets/lib/examples/counter_with_propagation/variants/stateful_widget_inherited_widget.dart": "c472f6c00eeef174db2552c13d959835",
"assets/lib/examples/animation_controller/variants/context_use.dart": "721c6296e04ffb6feb1c50685ad75441",
"assets/lib/examples/animation_controller/variants/context_watch.dart": "14e0198ed42908a5bc8db31b91fa64f2",
"assets/lib/examples/animation_controller/variants/animated_builder.dart": "c2c74a44f0e674a818b1893b9978c30b",
"assets/lib/examples/animation_controller/variants/context_plus.dart": "67423d875d7351761c763120aa04b6b2",
"assets/assets/fonts/JetBrainsMono.ttf": "507c9015cb1d9a8c667d684b0bef5f84",
"assets/assets/fonts/FiraCode.ttf": "975eb23ba46d8164c8401e265af15fd7",
"assets/assets/showcase/context_plus_showcase_v12.riv": "48d1ac4479a158b28f94151b529d4194",
"assets/assets/svg/emoji_u1f680.svg": "376926294b9cb392489b81d5bf957c59",
"assets/assets/svg/icon_arrow_collapse.svg": "7b9c6c56e3e85e67875c2c16bb8e83ba",
"assets/assets/svg/emoji_u1f44b.svg": "74ba447ac6bf6ede39ab0f45e1218731",
"assets/assets/svg/icon_application_braces.svg": "684a7077df7008d942c076bc83ccd47c",
"assets/assets/svg/icon_code_braces.svg": "f9e06e32ea7d2e4f332baf54cc526717",
"assets/assets/svg/icon_arrow_expand.svg": "519c7b07e3e878f8dec1e9ea9884e939",
"assets/assets/svg/emoji_u1f440.svg": "113a4aac918bb51b4de3a61454a8e218",
"assets/assets/svg/emoji_u1f91d.svg": "578cc2b6cf10a43ef586eb05c6382397",
"assets/assets/svg/emoji_u1f517.svg": "2937920ae6171449002939dcf0e189a8",
"assets/assets/svg/icon_skip_next_circle.svg": "7277860f1fe6f451135ec19dff3a9d01",
"assets/packages/syntax_highlight/grammars/yaml.json": "7c2dfa28161c688d8e09478a461f17bf",
"assets/packages/syntax_highlight/grammars/json.json": "e608a2cc8f3ec86a5b4af4d7025ae43f",
"assets/packages/syntax_highlight/grammars/sql.json": "957a963dfa0e8d634766e08c80e00723",
"assets/packages/syntax_highlight/grammars/dart.json": "b533a238112e4038ed399e53ca050e33",
"assets/packages/syntax_highlight/grammars/serverpod_protocol.json": "cc9b878a8ae5032ca4073881e5889fd5",
"assets/packages/syntax_highlight/themes/dark_plus.json": "b212b7b630779cb4955e27a1c228bf71",
"assets/packages/syntax_highlight/themes/dark_vs.json": "2839d5be4f19e6b315582a36a6dcd1c3",
"assets/packages/syntax_highlight/themes/light_vs.json": "8025deae1ca1a4d1cb803c7b9f8528a1",
"assets/packages/syntax_highlight/themes/light_plus.json": "2a29ad892e1f54e93062fee13b3688c6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "5d5441f50c0ebcb1ebd86034cd5af665",
"assets/NOTICES": "f9f51f8665edb11daa4c53fbeff4b827",
"main.dart.js": "507166c8719db7b49aef82d84ecea5c6",
"manifest.json": "2339e740f98f2b2f7be9a71238d78a4d",
"version.json": "7f8dc62c1f4d5bd242487095a468ef87",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"flutter_bootstrap.js": "7fc21aafe70e83269a51b0a4bc39c97d",
"main.dart.mjs": "f0e5754e745be38f4e937680e0843b79",
"favicon.png": "195ea9d74a64954b7503410035ff47d3",
"index.html": "8c83f96c782eef33be6809976d8cfb03",
"/": "8c83f96c782eef33be6809976d8cfb03",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"main.dart.wasm",
"main.dart.mjs",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
