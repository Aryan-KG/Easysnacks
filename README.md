# Food Delivery App (Assignment)

A Flutter app that implements a realistic single workflow for ordering food from local restaurants, following BLoC architecture and SOLID principles. Built as an internship assignment.

## Highlights
- BLoC for state management (`flutter_bloc`).
- Clean architecture layering (data, domain, presentation).
- Proper error handling and UX fallbacks.
- Aesthetically pleasing UI using Material 3.
- Unit tests for core BLoCs and widget smoke test.
- Self-contained app with mock local data source (no login required).

## Screens in the Workflow
1. Restaurant List
2. Restaurant Detail + Menu
3. Cart
4. Checkout (with address validation)
5. Order Confirmation

## Tech Stack
- Flutter 3 / Dart 3
- flutter_bloc, bloc_test
- get_it (DI)
- mocktail (testing)
- dartz, equatable

## Project Structure
```
lib/
  core/
    constants/
    errors/
    usecases/
    utils/
  di/
    injection_container.dart
  features/
    restaurants/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
    cart/
      domain/
        entities/
      presentation/
        bloc/
        pages/
    orders/
      domain/
        entities/
```
## Architecture Notes
- Domain layer contains `entities`, `repositories (abstraction)`, and `usecases`.
- Data layer implements repositories and data sources (mock local JSON-like models).
- Presentation layer uses BLoC (events, states) and declarative UI.
- DI with `get_it` in `lib/di/injection_container.dart` wires data source -> repo -> use cases -> blocs.

## Error Handling
- Domain-level `Failure` types: `ServerFailure`, `NetworkFailure`, `CacheFailure`, `ValidationFailure` in `lib/core/errors/`.
- UI shows friendly messages and retry where applicable.
- Checkout validates the delivery address and blocks order placement on invalid input.
- Cart prevents mixing restaurants; attempting to add from a different restaurant resets the cart for a consistent order.

## Design Choices / UX
- Material 3 theme with a deep orange seed color for a modern aesthetic.
- Card-based restaurant list with hero images, chips for meta info (ETA, delivery, categories).
- Menu items have clear CTAs to add to cart.
- Sticky cart summary with totals and CTA to proceed.

## How to Run
1. Ensure Flutter is installed and set up.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Running Tests
- Unit and widget tests:
  ```bash
  flutter test -r expanded
  ```

## What’s Tested
- `RestaurantBloc` happy/error paths.
- `CartBloc` add/increase/decrease/clear logic.
- Widget test verifying the home screen loads.

## Extensibility Ideas
- Replace mock data source with remote API (retrofit/http) with caching.
- Add search, filters, and restaurant open/close logic tied to time.
- Promo codes and payment integration at checkout.
- Order tracking with live status updates.

## Notes for Reviewers
- The app focuses on a single realistic order workflow with clear separation of concerns and test coverage for business logic.
- All code adheres to SOLID principles and is structured for maintainability.

