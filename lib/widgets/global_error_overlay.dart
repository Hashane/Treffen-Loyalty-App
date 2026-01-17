import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Global error overlay widget that wraps the app
class GlobalErrorOverlay extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, ErrorOverlayState state)? overlayWidgetBuilder;

  const GlobalErrorOverlay({super.key, required this.child, this.overlayWidgetBuilder});

  @override
  State<GlobalErrorOverlay> createState() => _GlobalErrorOverlayState();
}

class _GlobalErrorOverlayState extends State<GlobalErrorOverlay> {
  final ErrorOverlayController _controller = ErrorOverlayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ErrorOverlayInherited(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                widget.child,
                if (_controller.isVisible)
                  widget.overlayWidgetBuilder?.call(context, _controller.state) ??
                      _DefaultErrorOverlay(state: _controller.state),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Controller for managing error overlay state
class ErrorOverlayController extends ChangeNotifier {
  ErrorOverlayState _state = const ErrorOverlayState();

  ErrorOverlayState get state => _state;
  bool get isVisible => _state.isVisible;

  void show({
    required String message,
    String? title,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    bool dismissible = true,
  }) {
    _state = ErrorOverlayState(
      isVisible: true,
      message: message,
      title: title,
      onRetry: onRetry,
      onDismiss: onDismiss,
      dismissible: dismissible,
    );
    notifyListeners();
  }

  void hide() {
    if (_state.onDismiss != null) {
      _state.onDismiss!();
    }
    _state = const ErrorOverlayState();
    notifyListeners();
  }
}

/// State object for error overlay
class ErrorOverlayState {
  final bool isVisible;
  final String? message;
  final String? title;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool dismissible;

  const ErrorOverlayState({
    this.isVisible = false,
    this.message,
    this.title,
    this.onRetry,
    this.onDismiss,
    this.dismissible = true,
  });
}

/// InheritedWidget to provide error overlay access throughout the app
class _ErrorOverlayInherited extends InheritedWidget {
  final ErrorOverlayController controller;

  const _ErrorOverlayInherited({required this.controller, required super.child});

  @override
  bool updateShouldNotify(_ErrorOverlayInherited oldWidget) {
    return controller != oldWidget.controller;
  }
}

/// Extension to easily access error overlay from BuildContext
extension ErrorOverlayExtension on BuildContext {
  ErrorOverlayController get errorOverlay {
    final inherited = dependOnInheritedWidgetOfExactType<_ErrorOverlayInherited>();
    assert(
      inherited != null,
      'No GlobalErrorOverlay found in widget tree. '
      'Make sure to wrap your app with GlobalErrorOverlay.',
    );
    return inherited!.controller;
  }
}

/// Default error overlay UI
class _DefaultErrorOverlay extends StatelessWidget {
  final ErrorOverlayState state;

  const _DefaultErrorOverlay({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.scrim.withValues(alpha: 0.6),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Container(
              constraints: BoxConstraints(maxWidth: 400.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Error icon with gradient background
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.error.withValues(alpha: 0.1),
                            colorScheme.error.withValues(alpha: 0.2),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: colorScheme.error,
                        size: 36.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Title
                    Text(
                      state.title ?? 'Oops! Something went wrong',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),

                    // Message
                    Text(
                      state.message ?? 'An unexpected error occurred',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),

                    // Action buttons
                    Row(
                      children: [
                        // Dismiss button (if dismissible)
                        if (state.dismissible) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.errorOverlay.hide(),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Dismiss',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                        ],

                        // Retry button (if onRetry provided)
                        if (state.onRetry != null)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.errorOverlay.hide();
                                state.onRetry!();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Try Again',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),

                        // If no retry and not dismissible, show OK button
                        if (state.onRetry == null && !state.dismissible)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => context.errorOverlay.hide(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'OK',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
