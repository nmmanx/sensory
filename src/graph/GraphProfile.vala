public class GraphProfile {
    public string feature_name { private set; get; }
    public string graph_title { private set; get; }

    public string x_title { private set; get; }
    public string x_unit { private set; get; }
    public double x_upper { private set; get; }
    public double x_lower { private set; get; }
    public double x_step { private set; get; }

    public uint time_window { private set; get; }
    public uint time_window_step { private set; get; }

    private GraphProfile (string feature) {
        this.feature_name = feature;
    }

    public class Builder {
        private string feature_name;
        private string graph_title;
        private string x_title;
        private string x_unit;
        private double x_upper;
        private double x_lower;
        private double x_step;
        private uint time_window;
        private uint time_window_step;

        public Builder (string feature) {
            this.feature_name = feature;
        }

        public Builder set_graph_title (string tt) {
            this.graph_title = tt;
            return this;
        }

        public Builder set_x_title (string tt) {
            this.x_title = tt;
            return this;
        }

        public Builder set_x_unit (string unit) {
            this.x_unit = unit;
            return this;
        }

        public Builder set_x_limit (double upper, double lower, double step) {
            this.x_upper = upper;
            this.x_lower = lower;
            this.x_step = step;
            return this;
        }

        public Builder set_time_window (uint sec) {
            this.time_window = sec;
            return this;
        }

        public Builder set_time_window_step (uint sec) {
            this.time_window_step = sec;
            return this;
        }

        public GraphProfile build () {
            GraphProfile pf = new GraphProfile (this.feature_name);
            pf.graph_title = this.graph_title;
            pf.x_title = this.x_title;
            pf.x_upper = this.x_upper;
            pf.x_lower = this.x_lower;
            pf.x_step = this.x_step;
            pf.time_window = this.time_window;
            pf.time_window_step = this.time_window_step;
            return pf;
        }
    }
}