'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/NOTICES": "40fb04f673bd7a687db5492d7e44b5ba",
"assets/AssetManifest.bin.json": "eddd33a3e73f6c8f7f351271de6ca814",
"assets/FontManifest.json": "5d5441f50c0ebcb1ebd86034cd5af665",
"assets/assets/fonts/FiraCode.ttf": "975eb23ba46d8164c8401e265af15fd7",
"assets/assets/fonts/JetBrainsMono.ttf": "507c9015cb1d9a8c667d684b0bef5f84",
"assets/assets/showcase/context_plus_showcase_v12.riv": "48d1ac4479a158b28f94151b529d4194",
"assets/assets/svg/icon_arrow_expand.svg": "519c7b07e3e878f8dec1e9ea9884e939",
"assets/assets/svg/emoji_u1f91d.svg": "578cc2b6cf10a43ef586eb05c6382397",
"assets/assets/svg/icon_code_braces.svg": "f9e06e32ea7d2e4f332baf54cc526717",
"assets/assets/svg/icon_arrow_collapse.svg": "7b9c6c56e3e85e67875c2c16bb8e83ba",
"assets/assets/svg/emoji_u1f680.svg": "376926294b9cb392489b81d5bf957c59",
"assets/assets/svg/icon_application_braces.svg": "684a7077df7008d942c076bc83ccd47c",
"assets/assets/svg/icon_skip_next_circle.svg": "7277860f1fe6f451135ec19dff3a9d01",
"assets/assets/svg/emoji_u1f44b.svg": "74ba447ac6bf6ede39ab0f45e1218731",
"assets/assets/svg/emoji_u1f440.svg": "113a4aac918bb51b4de3a61454a8e218",
"assets/assets/svg/emoji_u1f517.svg": "2937920ae6171449002939dcf0e189a8",
"assets/pubspec.yaml": "5e2b7cea9b1ce3d8e1dcb531922a5db8",
"assets/lib/examples/rainbow/variants/stateful_widget.dart": "668e6bfc8c971f77bee0e570c129d0a4",
"assets/lib/examples/rainbow/variants/context_plus.dart": "fd38c2d2600310328786205eea09dfc7",
"assets/lib/examples/showcase/variants/pure_flutter.dart": "b431df13cf15e96e4384ed1a8796a2b3",
"assets/lib/examples/showcase/variants/context_plus.dart": "2f3a54b221d978f39f92f26a6160183d",
"assets/lib/examples/counter_with_propagation/variants/context_plus_stateful_bind_value.dart": "b511c3b3765e7abf21e281ae7d5f5dd7",
"assets/lib/examples/counter_with_propagation/variants/stateful_widget_explicit_params.dart": "f1ecca21ff5b89b27023ecc09504f5f3",
"assets/lib/examples/counter_with_propagation/variants/context_plus_bind_watch.dart": "5e9f390c4077cdb6a22de3ab5ccc4dfb",
"assets/lib/examples/counter_with_propagation/variants/stateful_widget_inherited_widget.dart": "4978dd00249f1722161f7b5fc38203a8",
"assets/lib/examples/derived_state/variants/context_plus_value_notifier_function.dart": "e2439a29ec1317df404813d12f5b3b1a",
"assets/lib/examples/derived_state/variants/context_plus_change_notifier.dart": "8cd24b030b1bf17bf2eacb8ac6b75e50",
"assets/lib/examples/counter/variants/stateful_widget.dart": "6d493eca3393db935eb2a1dd989d8ff4",
"assets/lib/examples/counter/variants/context_plus.dart": "52019d1d35cec8f7a6660322f4657f3c",
"assets/lib/examples/country_search/variants/context_plus_state_1.dart": "d75d92e305055b361d1fe5d9bc3ae69e",
"assets/lib/examples/country_search/variants/context_plus_state_2.dart": "7f672ecbe7b298d14788e532f536d5b0",
"assets/lib/examples/country_search/variants/stateful_and_inherited.dart": "55f5da19be94d023438db7c3054c91eb",
"assets/lib/examples/country_search/variants/stateful_widget.dart": "75b077e58c1bf887010465e4db7b5734",
"assets/lib/examples/country_search/variants/context_plus.dart": "01f621088257824c119beef3540c08fa",
"assets/lib/examples/country_search/util/countries.json": "967e6fcbee63510b3bf4a41ea78dbff8",
"assets/lib/examples/animation_controller/variants/context_watch.dart": "d7bce43c3595cd3bafb9e29e2d52e1c9",
"assets/lib/examples/animation_controller/variants/context_plus.dart": "67423d875d7351761c763120aa04b6b2",
"assets/lib/examples/animation_controller/variants/animated_builder.dart": "9dc92a18075bc62e74fa109b00500913",
"assets/lib/examples/nested_scopes/variants/context_plus.dart": "de4dca023e05c37cb741792576810e9d",
"assets/fonts/MaterialIcons-Regular.otf": "bbabafc31e9d3c87e0b4eb10166c4c35",
"assets/AssetManifest.json": "52041c5e60dab9dd62ca5da48056b104",
"assets/AssetManifest.bin": "07e246f03273797d183542a4b63a9d96",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/syntax_highlight/grammars/dart.json": "b533a238112e4038ed399e53ca050e33",
"assets/packages/syntax_highlight/grammars/json.json": "e608a2cc8f3ec86a5b4af4d7025ae43f",
"assets/packages/syntax_highlight/grammars/sql.json": "957a963dfa0e8d634766e08c80e00723",
"assets/packages/syntax_highlight/grammars/yaml.json": "7c2dfa28161c688d8e09478a461f17bf",
"assets/packages/syntax_highlight/grammars/serverpod_protocol.json": "cc9b878a8ae5032ca4073881e5889fd5",
"assets/packages/syntax_highlight/themes/dark_vs.json": "2839d5be4f19e6b315582a36a6dcd1c3",
"assets/packages/syntax_highlight/themes/dark_plus.json": "b212b7b630779cb4955e27a1c228bf71",
"assets/packages/syntax_highlight/themes/light_vs.json": "8025deae1ca1a4d1cb803c7b9f8528a1",
"assets/packages/syntax_highlight/themes/light_plus.json": "2a29ad892e1f54e93062fee13b3688c6",
"CNAME": "02e1674c9e6dc4d9e12a876d583ece8f",
"index.html": "8c83f96c782eef33be6809976d8cfb03",
"/": "8c83f96c782eef33be6809976d8cfb03",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"flutter_bootstrap.js": "e3d940894c9d4813ff7db47eb7f50956",
"main.dart.js": "8ebb8cb9975b9e20298323499d0e0a62",
"icons/Icon-maskable-512.png": "1c3b3a232b8924d3de3807db7be445e6",
"icons/Icon-maskable-192.png": "d1da14f34e29939620c344bdff682cc7",
"icons/Icon-512.png": "af8d06d8d3445769a1ff18a4ccff298b",
"icons/Icon-192.png": "42730ac22d2b8791cb089b198e99c363",
"manifest.json": "2339e740f98f2b2f7be9a71238d78a4d",
"version.json": "7f8dc62c1f4d5bd242487095a468ef87",
"favicon.png": "195ea9d74a64954b7503410035ff47d3"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
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
