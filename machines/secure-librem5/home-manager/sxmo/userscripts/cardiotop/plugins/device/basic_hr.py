"""
A processor for calculating basic heart rate statistics.
"""

class HRStats:
    """Calculates and stores basic heart rate statistics for a session."""
    def __init__(self):
        """Initializes a new HRStats object."""
        self.min_hr = None
        self.max_hr = None
        self.avg_hr = None
        self._hr_readings = []

    def update(self, data):
        """
        Updates the statistics with a new data dictionary.

        Args:
            data (dict): The raw data dictionary from the device stream.
                         It is expected to have a "heart_rate" key.
        """
        hr = data.get("heart_rate")
        if hr is None:
            return

        if self.min_hr is None or hr < self.min_hr:
            self.min_hr = hr
        
        if self.max_hr is None or hr > self.max_hr:
            self.max_hr = hr

        self._hr_readings.append(hr)
        self.avg_hr = sum(self._hr_readings) / len(self._hr_readings)

    def report(self):
        """
        Returns a dictionary of the current statistics.

        The average heart rate is formatted to two decimal places.

        Returns:
            dict: A dictionary containing the min_hr, max_hr, and avg_hr.
        """
        return {
            "min_hr": self.min_hr,
            "max_hr": self.max_hr,
            "avg_hr": f"{self.avg_hr:.2f}" if self.avg_hr is not None else None,
        }

def get_stats_provider(config: dict = None):
    """
    Factory function for the `basic_hr` device plugin.

    Args:
        config (dict, optional): A dictionary of configuration options.
                                 Defaults to None. This plugin currently
                                 does not use any config options.

    Returns:
        HRStats: An instance of the HRStats class.
    """
    return HRStats()
