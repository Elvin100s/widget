# CarouselView Widget Demo

A Flutter application demonstrating the `CarouselView` widget introduced in Material 3 (Flutter 3.19+).

---

## Features

| Feature | Description |
|---|---|
| **Default CarouselView** | Horizontally scrollable cards with fixed width, shrink extent, and item snapping |
| **Page Indicator** | Animated dot row that tracks the active card in real time |
| **CarouselController** | Programmatic Prev / Next navigation with auto-disabling buttons |
| **CarouselView.weighted** | Cards sized by flex weights — the first card is always the largest |
| **onTap handler** | Tapping any card shows a snackbar with the card's name |
| **Reusable card widget** | `_CarouselCard` is shared by both carousels |

---

## Project Structure

```
lib/
└── main.dart        # All app code — MyApp, DemoPage, _CarouselCard
```

---

## Key Code Sections

| Section | Lines |
|---|---|
| Item data list | 31–38 |
| CarouselController + scroll listener | 40–53 |
| onTap snackbar handler | 62–69 |
| AppBar | 76–79 |
| Default CarouselView | 99–113 |
| Page indicator dots | 128–142 |
| Prev / Next buttons | 145–184 |
| Weighted CarouselView | 189–208 |
| \_CarouselCard widget | 219–254 |

---

## How It Works

### CarouselController
A `CarouselController` is attached to the first carousel. A scroll listener calculates the active index from the scroll offset and updates the dot indicator live:

```dart
_controller.addListener(() {
  final newIndex = (_controller.offset / 260).round().clamp(0, _items.length - 1);
  if (newIndex != _currentIndex) setState(() => _currentIndex = newIndex);
});
```

### CarouselView.weighted
Uses `flexWeights` to define proportional card sizes. The leading card gets the most space:

```dart
CarouselView.weighted(
  flexWeights: const [3, 2, 1],
  ...
)
```

### Reusable Card
`_CarouselCard` accepts a title, icon, and color — both carousels pass different data to the same widget, demonstrating the value of component reuse.

---

## Three Key Attributes

### 1. `itemExtent`
Controls the width of each card in the carousel. Default has no set value — you must provide one. Set to `260` in this demo. Increasing it makes cards wider; decreasing it shows more cards at once.

### 2. `itemSnapping`
Controls whether cards snap into position when you release. Defaults to `false`. Set to `true` in this demo — when you let go mid-scroll, the carousel automatically snaps to the nearest card instead of stopping freely.

### 3. `shrinkExtent`
Controls the minimum width a partially visible card can shrink to as it scrolls off-screen. Defaults to `0`. Set to `160` in this demo — cards compress to 160px before disappearing, creating a smooth peek effect at the edges.

---

## Requirements

- Flutter 3.19 or later
- Dart 3.x
- Material 3 enabled (`useMaterial3: true`)

---

## Screenshot

![App Screenshot](carousel%20demo.jpeg)

## Running the App

```bash
flutter pub get
flutter run
```
