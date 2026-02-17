// --------------------------------
// Purpose: Provides basic functions such as max, min, etc.
// --------------------------------

namespace math {

    // Get the maximum value.
    double max(const array<double>&in arr) {
        double max_ = -9223372036854775808;
        foreach (double a : arr) {
            if (a > max_) {
                max_ = a;
            }
        }

        return max_;
    }

    double abs(const double&in a) {
        return a < 0 ? -a : a;
    }
}