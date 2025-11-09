"""
Calorie Counter Activity Plugin for Cardiotop.

Estimates calorie expenditure based on heart rate and user data.
"""

class CalorieCounter:
    def __init__(self, config):
        self.age = config.get("age")
        self.weight_kg = config.get("weight_kg")
        self.gender = config.get("gender", "male").lower()
        self.total_calories = 0
        self.last_timestamp = None

        if not all([self.age, self.weight_kg, self.gender]):
            raise ValueError("CalorieCounter plugin requires age, weight_kg, and gender in its config.")

    def process(self, data):
        """
        Processes a single data point to update the calorie count.
        """
        if "hr" not in data or "timestamp" not in data:
            return data

        if self.last_timestamp is None:
            self.last_timestamp = data["timestamp"]
            return data

        # Calculate time delta in minutes
        time_delta_seconds = data["timestamp"] - self.last_timestamp
        time_delta_minutes = time_delta_seconds / 60.0
        self.last_timestamp = data["timestamp"]

        # Estimate calories burned in the interval
        calories_burned = 0
        if self.gender == "male":
            calories_burned = ((-55.0969 + (0.6309 * data["hr"]) + (0.1988 * self.weight_kg) + (0.2017 * self.age)) / 4.184) * time_delta_minutes
        else: # female
            calories_burned = ((-20.4022 + (0.4472 * data["hr"]) - (0.1263 * self.weight_kg) + (0.074 * self.age)) / 4.184) * time_delta_minutes
        
        if calories_burned > 0:
            self.total_calories += calories_burned

        data["calories"] = round(self.total_calories, 2)
        return data

def get_plugin(config):
    """
    Factory function to create an instance of the CalorieCounter plugin.
    """
    return CalorieCounter(config)