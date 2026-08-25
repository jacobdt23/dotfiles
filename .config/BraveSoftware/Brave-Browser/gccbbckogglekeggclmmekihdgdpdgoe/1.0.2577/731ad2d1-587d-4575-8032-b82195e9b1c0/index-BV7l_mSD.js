//#region ../../apis/accessibility.ts
/**
* Public.
*/
var prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
window.matchMedia("(prefers-reduced-transparency: reduce)").matches;
//#endregion
//#region ../../apis/debug.ts
/**
* Public.
*/
function isDebugEnabled() {
	const debug = document.body?.dataset?.debug;
	return debug === "" || debug === "true";
}
//#endregion
//#region ../../apis/log.ts
/**
* Private.
*/
var debugEnabled = null;
/**
* Public.
*/
function debugLog(...args) {
	if (debugEnabled === null) debugEnabled = isDebugEnabled();
	if (debugEnabled) console.debug(...args);
}
//#endregion
//#region ../../apis/data-attr.ts
function parseNumberDataAttr(dataAttr, fallback = null) {
	if (dataAttr === void 0 || dataAttr.trim() === "") return fallback;
	const parsed = Number(dataAttr);
	if (!Number.isFinite(parsed)) {
		debugLog(`Invalid number attribute value "${dataAttr}", using fallback ${String(fallback)}.`);
		return fallback;
	}
	return parsed;
}
//#endregion
//#region ../../apis/event-binder.ts
/**
* Private.
*/
function bindClickToSelectors(selectors, onElement) {
	[selectors].flat().forEach((selector) => {
		const elements = document.querySelectorAll(selector);
		if (elements.length === 0) {
			console.warn(`No elements found for selector ${selector}.`);
			return;
		}
		elements.forEach(onElement);
	});
}
/**
* Public.
*/
function bindClickHandler(selectors, onClick) {
	bindClickToSelectors(selectors, (element) => element.addEventListener("click", onClick));
}
//#endregion
//#region ../../apis/os.ts
/**
* Public.
*/
var OperatingSystemType = /* @__PURE__ */ function(OperatingSystemType) {
	OperatingSystemType["Android"] = "Android";
	OperatingSystemType["iOS"] = "iOS";
	OperatingSystemType["Windows"] = "Windows";
	OperatingSystemType["Mac"] = "Mac";
	OperatingSystemType["Linux"] = "Linux";
	OperatingSystemType["Unknown"] = "Unknown";
	return OperatingSystemType;
}({});
var operatingSystemType = (() => {
	const userAgentData = navigator.userAgentData;
	if (userAgentData?.platform) switch (userAgentData.platform) {
		case "Android": return "Android";
		case "iOS": return "iOS";
		case "Windows": return "Windows";
		case "macOS": return "Mac";
		case "Linux": return "Linux";
		default: return "Unknown";
	}
	const userAgent = navigator.userAgent;
	if (/android/i.test(userAgent)) return "Android";
	if (/iPad|iPhone|iPod/.test(userAgent)) return "iOS";
	if (/Win/.test(userAgent)) return "Windows";
	if (/Mac/.test(userAgent)) return "Mac";
	if (/Linux/.test(userAgent)) return "Linux";
	return "Unknown";
})();
//#endregion
//#region ../../apis/bridge.ts
/**
* Private.
*/
var RICH_MEDIA_EVENT = "richMediaEvent";
function trustedOrigin() {
	return operatingSystemType === OperatingSystemType.Android ? "chrome://new-tab-takeover" : "chrome://newtab";
}
/**
* Public.
*/
function isTrustedOrigin(origin) {
	return origin === trustedOrigin();
}
function postMessage(payload) {
	window.parent.postMessage(payload, trustedOrigin());
}
function postRichMediaEvent(eventType) {
	postMessage({
		type: RICH_MEDIA_EVENT,
		value: eventType
	});
}
//#endregion
//#region ../../apis/event-dispatcher.ts
/**
* Private.
*/
var dispatchedEvents = /* @__PURE__ */ new Set();
/**
* Public.
*/
var richMediaEventTypes = {
	CLICK: "click",
	INTERACTION: "interaction",
	MEDIA_PLAY: "mediaPlay",
	MEDIA_25: "media25",
	MEDIA_100: "media100"
};
function dispatchRichMediaEvent(eventType) {
	if (dispatchedEvents.has(eventType)) {
		debugLog(`${eventType} event already dispatched, skipping.`);
		return;
	}
	dispatchedEvents.add(eventType);
	debugLog(`Dispatching ${eventType} event.`);
	postRichMediaEvent(eventType);
}
function bindAndDispatchClickEvent(selectors) {
	bindClickToSelectors(selectors, (element) => element.addEventListener("click", () => dispatchRichMediaEvent(richMediaEventTypes.CLICK)));
}
//#endregion
//#region ../../apis/gpu.ts
function isNavigatorWithGPU(navigator) {
	return "gpu" in navigator;
}
function isSoftwareRenderer(rendererName) {
	return /swiftshader|llvmpipe|softpipe|software/i.test(rendererName);
}
async function hasWebGPUAcceleration() {
	if (!isNavigatorWithGPU(navigator)) return false;
	try {
		const gpuAdapter = await navigator.gpu.requestAdapter();
		if (!gpuAdapter) return false;
		return !isSoftwareRenderer(gpuAdapter.name);
	} catch {
		return false;
	}
}
function hasWebGLAcceleration() {
	for (const type of ["webgl2", "webgl"]) {
		const canvasElement = document.createElement("canvas");
		const webGLContext = canvasElement.getContext(type);
		if (!webGLContext) continue;
		const debugRendererInfo = webGLContext.getExtension("WEBGL_debug_renderer_info");
		const loseContext = webGLContext.getExtension("WEBGL_lose_context");
		if (!debugRendererInfo) {
			if (loseContext) loseContext.loseContext();
			else canvasElement.width = 0;
			continue;
		}
		const isHardwareRenderer = !isSoftwareRenderer(webGLContext.getParameter(debugRendererInfo.UNMASKED_RENDERER_WEBGL) ?? "");
		if (loseContext) loseContext.loseContext();
		else canvasElement.width = 0;
		if (isHardwareRenderer) return true;
	}
	return false;
}
/**
* Public.
*/
async function supportsGpuAcceleration() {
	const webGPUAccelerated = await hasWebGPUAcceleration();
	const webGLAccelerated = !webGPUAccelerated && hasWebGLAcceleration();
	const gpuAccelerated = webGPUAccelerated || webGLAccelerated;
	debugLog(`WebGPU supported ${webGPUAccelerated}, WebGL supported ${webGLAccelerated}.`);
	return gpuAccelerated;
}
//#endregion
//#region ../../apis/geometry.ts
function clampRect(rect, containerRect) {
	const clampedX = Math.max(containerRect.x, Math.min(rect.x, containerRect.x + containerRect.width));
	const clampedY = Math.max(containerRect.y, Math.min(rect.y, containerRect.y + containerRect.height));
	return {
		x: clampedX,
		y: clampedY,
		width: Math.max(0, Math.min(rect.width, containerRect.x + containerRect.width - clampedX)),
		height: Math.max(0, Math.min(rect.height, containerRect.y + containerRect.height - clampedY))
	};
}
//#endregion
//#region ../../apis/random.ts
function shuffle(array) {
	const shuffled = [...array];
	for (let i = shuffled.length; i > 1; i--) {
		const j = Math.floor(Math.random() * i);
		[shuffled[i - 1], shuffled[j]] = [shuffled[j], shuffled[i - 1]];
	}
	return shuffled;
}
//#endregion
//#region ../../apis/platform.ts
/**
* Public.
*/
var isMobile = (() => {
	const userAgentData = navigator.userAgentData;
	if (userAgentData?.mobile !== void 0) return userAgentData.mobile;
	return operatingSystemType === OperatingSystemType.Android || operatingSystemType === OperatingSystemType.iOS;
})();
//#endregion
//#region ../../apis/safe-area-debug.ts
/**
* Private.
*/
function drawSafeAreaDebugOverlay(rect) {
	const id = "debug-safe-area";
	let debugOverlayElement = document.getElementById(id);
	if (!debugOverlayElement) {
		debugOverlayElement = document.createElement("div");
		debugOverlayElement.id = id;
		debugOverlayElement.style.position = "fixed";
		debugOverlayElement.style.boxSizing = "border-box";
		debugOverlayElement.style.background = "transparent";
		debugOverlayElement.style.border = "4px solid rgba(0, 255, 0, 0.7)";
		debugOverlayElement.style.pointerEvents = "none";
		debugOverlayElement.style.zIndex = "2147483647";
		document.body.appendChild(debugOverlayElement);
	}
	debugOverlayElement.style.left = `${rect.x}px`;
	debugOverlayElement.style.top = `${rect.y}px`;
	debugOverlayElement.style.width = `${rect.width}px`;
	debugOverlayElement.style.height = `${rect.height}px`;
}
/**
* Public.
*/
function maybeDrawSafeAreaDebugOverlay(rect) {
	if (!document.body) {
		document.addEventListener("DOMContentLoaded", () => maybeDrawSafeAreaDebugOverlay(rect), { once: true });
		return;
	}
	if (isDebugEnabled()) drawSafeAreaDebugOverlay(rect);
}
//#endregion
//#region ../../apis/safe-area.ts
/**
* Private.
*/
var currentSafeAreaRect = null;
var isSafeAreaInitialized = false;
var pendingSafeAreaLayoutUpdate = false;
var resolveSafeAreaReady = null;
new Promise((resolve) => {
	resolveSafeAreaReady = resolve;
});
var LEGACY_WIDE_DESKTOP_INSET = {
	top: 128,
	right: 24,
	bottom: 200,
	left: 24
};
var LEGACY_NARROW_DESKTOP_INSET = {
	top: 224,
	right: 24,
	bottom: 200,
	left: 24
};
var LEGACY_MOBILE_INSET = {
	top: 156,
	right: 12,
	bottom: 58,
	left: 12
};
var NARROW_DESKTOP_MAX_WIDTH = 643;
function legacySafeAreaInsets() {
	if (isMobile) return LEGACY_MOBILE_INSET;
	if (window.innerWidth <= NARROW_DESKTOP_MAX_WIDTH) return LEGACY_NARROW_DESKTOP_INSET;
	return LEGACY_WIDE_DESKTOP_INSET;
}
function legacySafeAreaRect() {
	const inset = legacySafeAreaInsets();
	return new DOMRectReadOnly(inset.left, inset.top, window.innerWidth - (inset.left + inset.right), window.innerHeight - (inset.top + inset.bottom));
}
function getSafeAreaRect() {
	return currentSafeAreaRect ?? legacySafeAreaRect();
}
function setSafeAreaCSSVariables(rect) {
	const style = document.documentElement.style;
	const top = rect.y;
	const right = window.innerWidth - rect.right;
	const bottom = window.innerHeight - rect.bottom;
	const left = rect.x;
	style.setProperty("--safe-area-x", `${rect.x}px`);
	style.setProperty("--safe-area-y", `${rect.y}px`);
	style.setProperty("--safe-area-width", `${rect.width}px`);
	style.setProperty("--safe-area-height", `${rect.height}px`);
	style.setProperty("--safe-area-top", `${top}px`);
	style.setProperty("--safe-area-bottom", `${bottom}px`);
	style.setProperty("--safe-area-left", `${left}px`);
	style.setProperty("--safe-area-right", `${right}px`);
	style.setProperty("--safe-area", `${top}px ${right}px ${bottom}px ${left}px`);
	maybeDrawSafeAreaDebugOverlay(rect);
}
function scheduleAfterDom(onReady) {
	if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", () => requestAnimationFrame(onReady), { once: true });
	else requestAnimationFrame(onReady);
}
function notifySafeAreaLayoutChange() {
	debugLog("Dispatching layoutSafeArea event.");
	window.dispatchEvent(new CustomEvent("layoutSafeArea"));
}
function updateSafeAreaLayout() {
	if (pendingSafeAreaLayoutUpdate) {
		debugLog("Safe area layout update already pending, skipping.");
		return;
	}
	pendingSafeAreaLayoutUpdate = true;
	debugLog("Safe area layout update scheduled. isMobile:", isMobile, "innerWidth:", window.innerWidth, "innerHeight:", window.innerHeight);
	scheduleAfterDom(() => {
		pendingSafeAreaLayoutUpdate = false;
		const usingBridgeRect = currentSafeAreaRect !== null;
		const safeAreaRect = getSafeAreaRect();
		debugLog("Safe area applying. source:", usingBridgeRect ? "bridge" : "legacy", "rect:", safeAreaRect);
		setSafeAreaCSSVariables(safeAreaRect);
		notifySafeAreaLayoutChange();
		resolveSafeAreaReady?.();
	});
}
function subscribeToSafeAreaLayoutChanges() {
	window.addEventListener("message", (messageEvent) => {
		if (!isTrustedOrigin(messageEvent.origin)) return;
		const { type, value } = messageEvent.data ?? {};
		debugLog("Safe area bridge message. type:", type, "origin:", messageEvent.origin);
		if (type === "richMediaSafeRect" && value && typeof value.x === "number" && typeof value.y === "number" && typeof value.width === "number" && typeof value.height === "number") {
			debugLog("Safe area bridge rect received. raw:", value);
			const clamped = clampRect({
				x: value.x,
				y: value.y,
				width: value.width,
				height: value.height
			}, {
				x: 0,
				y: 0,
				width: window.innerWidth,
				height: window.innerHeight
			});
			debugLog("Safe area bridge rect clamped:", clamped);
			currentSafeAreaRect = new DOMRectReadOnly(clamped.x, clamped.y, clamped.width, clamped.height);
			debugLog("Safe area rect", currentSafeAreaRect);
			updateSafeAreaLayout();
		} else if (type !== void 0) debugLog("Safe area bridge message ignored. type:", type, "value:", value);
	});
	window.addEventListener("resize", updateSafeAreaLayout);
}
function initSafeArea() {
	if (isSafeAreaInitialized) return;
	isSafeAreaInitialized = true;
	updateSafeAreaLayout();
	subscribeToSafeAreaLayoutChanges();
}
//#endregion
//#region ../../apis/carousel/script.ts
async function initCarousel() {
	initSafeArea();
	const isScrollEndEventSupported = "onscrollend" in document.createElement("div");
	const maybeCarousel = document.querySelector(".carousel");
	if (!maybeCarousel) return;
	const carousel = maybeCarousel;
	if (document.body.hasAttribute("data-hide-navigation")) {
		const navigationContainer = document.querySelector(".carousel-navigation-container");
		if (navigationContainer) navigationContainer.style.display = "none";
	}
	carousel.dataset.animationStyle ??= "fade";
	const animationStyle = carousel.dataset.animationStyle;
	const slides = document.querySelectorAll(".carousel-slide");
	if (!slides) return;
	let currentSlide = 0;
	const shouldLoop = carousel.hasAttribute("data-loop");
	const slideDisplayOrder = shuffleSlideDisplayOrder(carousel, slides);
	if (prefersReducedMotion) console.warn("User prefers reduced motion. Skipping animations.");
	const gpuAccelerated = await supportsGpuAcceleration();
	if (!gpuAccelerated) console.warn("GPU does not support acceleration. Skipping animations.");
	const DEFAULT_AUTOPLAY_INTERVAL_IN_SECONDS = 3;
	const DEFAULT_FADE_DURATION_IN_SECONDS = 1;
	let autoplayTimeout = null;
	let isFirstRun = true;
	let userInteracted = false;
	setSlideFocalPoints();
	displaySlide(currentSlide);
	addEventListeners();
	maybeCreatePaginationDots();
	maybeUpdatePaginationDots(currentSlide);
	maybeStartAutoplay();
	function shuffleSlideDisplayOrder(carousel, slides) {
		let slideDisplayOrder = Array.from(slides, (_, i) => i);
		if ((carousel.dataset.displayOrder || "shuffle") === "shuffle") {
			slideDisplayOrder = shuffle(slideDisplayOrder);
			const slidesArray = Array.from(slides);
			slideDisplayOrder.forEach((index) => {
				carousel.appendChild(slidesArray[index]);
			});
		}
		return slideDisplayOrder;
	}
	function setSlideFocalPoints() {
		document.querySelectorAll(".carousel-slide img").forEach((img) => {
			img.style.objectPosition = img.dataset.focalPoint || "center";
		});
	}
	function displaySlide(index) {
		if (index < 0 || index >= slides.length) return;
		const slideIndex = slideDisplayOrder[index];
		const skipTransition = prefersReducedMotion || !gpuAccelerated;
		if (animationStyle === "scroll") {
			scrollToSlide(index, skipTransition ? "auto" : "smooth");
			return;
		}
		fadeToSlide(slideIndex, skipTransition);
		isFirstRun = false;
	}
	function scrollToSlide(index, behavior) {
		carousel.scrollTo({
			left: index * carousel.clientWidth,
			behavior
		});
	}
	function fadeToSlide(slideIndex, skipTransition = false) {
		const duration = skipTransition ? 0 : fadeDuration();
		slides.forEach((slide, i) => {
			if (!isFirstRun && duration > 0) slide.style.transition = `opacity ${duration}s ease`;
			slide.classList.toggle("active", i === slideIndex);
		});
	}
	function nextSlideDelayInSeconds(intervalInSeconds) {
		return intervalInSeconds + (animationStyle !== "scroll" ? fadeDuration() : 0);
	}
	function nextSlide() {
		if (shouldLoop) currentSlide = (currentSlide + 1) % slides.length;
		else if (currentSlide < slides.length - 1) currentSlide++;
		else stopAutoplay();
		maybeUpdatePaginationDots(currentSlide);
		displaySlide(currentSlide);
	}
	function nextSlideWithUserInteraction() {
		userInteracted = true;
		resetAutoplay();
		nextSlide();
		dispatchRichMediaEvent(richMediaEventTypes.INTERACTION);
	}
	function prevSlide() {
		if (shouldLoop) currentSlide = (currentSlide - 1 + slides.length) % slides.length;
		else if (currentSlide > 0) currentSlide--;
		maybeUpdatePaginationDots(currentSlide);
		displaySlide(currentSlide);
	}
	function prevSlideWithUserInteraction() {
		userInteracted = true;
		resetAutoplay();
		prevSlide();
		dispatchRichMediaEvent(richMediaEventTypes.INTERACTION);
	}
	function maybeCreatePaginationDots() {
		const paginationDots = document.querySelector(".carousel-pagination-dots");
		if (!paginationDots) return;
		slides.forEach((_, i) => {
			const pagination_dot = document.createElement("span");
			pagination_dot.classList.add("carousel-pagination-dot");
			pagination_dot.addEventListener("click", () => {
				userInteracted = true;
				resetAutoplay();
				currentSlide = i;
				maybeUpdatePaginationDots(currentSlide);
				displaySlide(currentSlide);
				dispatchRichMediaEvent(richMediaEventTypes.INTERACTION);
			});
			paginationDots.appendChild(pagination_dot);
		});
	}
	function maybeUpdatePaginationDots(index) {
		if (index < 0 || index >= slides.length) return;
		document.querySelectorAll(".carousel-pagination-dot").forEach((paginationDot, i) => {
			paginationDot.classList.toggle("active", i === index);
		});
	}
	function addEventListeners() {
		document.addEventListener("contextmenu", (event) => event.preventDefault());
		document.addEventListener("visibilitychange", handleVisibilityChange);
		carousel.addEventListener("scroll", handleScroll);
		carousel.addEventListener("scrollend", handleScrollEnd);
		bindAndDispatchClickEvent(".carousel-slide img");
		bindClickHandler(".carousel-navigation.next", nextSlideWithUserInteraction);
		bindClickHandler(".carousel-navigation.prev", prevSlideWithUserInteraction);
	}
	function fadeDuration() {
		return parseNumberDataAttr(carousel.dataset.fadeDuration, DEFAULT_FADE_DURATION_IN_SECONDS) ?? DEFAULT_FADE_DURATION_IN_SECONDS;
	}
	function autoplayIntervalInSeconds() {
		if (!carousel.dataset.autoplay) return document.querySelector(".carousel-navigation-container") ? null : DEFAULT_AUTOPLAY_INTERVAL_IN_SECONDS;
		return parseNumberDataAttr(carousel.dataset.autoplay, null);
	}
	function maybeStartAutoplay() {
		if (userInteracted) return;
		const intervalInSeconds = autoplayIntervalInSeconds();
		if (intervalInSeconds !== null) startAutoplay(intervalInSeconds);
	}
	function startAutoplay(intervalInSeconds) {
		stopAutoplay();
		autoplayTimeout = window.setTimeout(() => onAutoplayTick(intervalInSeconds), intervalInSeconds * 1e3);
	}
	function onAutoplayTick(intervalInSeconds) {
		nextSlide();
		if (autoplayTimeout === null) return;
		autoplayTimeout = window.setTimeout(() => onAutoplayTick(intervalInSeconds), nextSlideDelayInSeconds(intervalInSeconds) * 1e3);
	}
	function stopAutoplay() {
		if (autoplayTimeout !== null) {
			clearTimeout(autoplayTimeout);
			autoplayTimeout = null;
		}
	}
	function resetAutoplay() {
		stopAutoplay();
		maybeStartAutoplay();
	}
	function handleVisibilityChange() {
		document.visibilityState === "visible" ? maybeStartAutoplay() : stopAutoplay();
	}
	function handleScroll() {
		if (animationStyle !== "scroll") return;
		resetAutoplay();
		currentSlide = Math.round(carousel.scrollLeft / carousel.clientWidth);
		if (!isScrollEndEventSupported) handleScrollEnd();
	}
	function handleScrollEnd() {
		if (animationStyle !== "scroll") return;
		maybeUpdatePaginationDots(currentSlide);
	}
}
//#endregion
//#region src/brand.ts
document.addEventListener("DOMContentLoaded", () => {
	initCarousel();
	bindAndDispatchClickEvent(".button");
});
//#endregion
