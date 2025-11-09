"""
Calorie Counter Activity Plugin for Cardiotop.

Estimates calorie expenditure based on heart rate and user data.
"""

class ActivityPlugin:
    """
    Estimates calorie expenditure based on heart rate, user biometrics, and time.
    This class adheres to the standard Activity Plugin interface for Cardiotop.
    """
    def __init__(self, config: dict):
        """
        Initializes the plugin with user-specific configuration.
        
        Args:
            config (dict): A dictionary containing user's age, weight_kg,
                           and assigned_sex.
        """
        self.age = config.get("age")
        self.weight_kg = config.get("weight_kg")
        self.assigned_sex = config.get("assigned_sex", "female").lower()
        self.total_calories = 0.0
        self.last_timestamp = None

        if not all([self.age, self.weight_kg, self.assigned_sex]):
            raise ValueError("CalorieCounter plugin requires 'age', 'weight_kg', and 'assigned_sex' in its config.")

    def process(self, aggregated_data: dict) -> dict:
        """
        Processes an aggregated data object to calculate calories burned.

        It finds the first available heart rate from the nested 'devices' dictionary,
        calculates calories burned since the last data point, and returns the
        cumulative total.

        Args:
            aggregated_data (dict): The combined data from all device streams.
        
        Returns:
            dict: A dictionary containing the calculated 'calories'.
        """
        current_timestamp = aggregated_data.get("timestamp")
        if not current_timestamp:
            return {}

        # Find the first available heart rate from any device
        heart_rate = None
        for device_data in aggregated_data.get("devices", {}).values():
            if 'heart_rate' in device_data:
                heart_rate = device_data['heart_rate']
                break
        
        if heart_rate is None:
            # If no heart rate is available, we can't calculate, but we can report the current total.
            return {"calories": round(self.total_calories, 2)}

        # On the first run, just set the timestamp and return
        if self.last_timestamp is None:
            self.last_timestamp = current_timestamp
            return {"calories": 0.0}

        # Calculate time delta in minutes
        time_delta_seconds = current_timestamp - self.last_timestamp
        if time_delta_seconds <= 0:
            return {"calories": round(self.total_calories, 2)}
        
        time_delta_minutes = time_delta_seconds / 60.0
        self.last_timestamp = current_timestamp

        # Estimate calories burned in the interval using formulas adapted from Mifflin-St Jeor.
        # Source: J Am Diet Assoc. 1990;90(2):187-93.
        # These equations use sex assigned at birth due to physiological differences in metabolic rates.
        calories_in_interval = 0
        if self.assigned_sex == "male":
            calories_in_interval = ((-55.0969 + (0.6309 * heart_rate) + (0.1988 * self.weight_kg) + (0.2017 * self.age)) / 4.184) * time_delta_minutes
        else:  # Defaults to female
            calories_in_interval = ((-20.4022 + (0.4472 * heart_rate) - (0.1263 * self.weight_kg) + (0.074 * self.age)) / 4.184) * time_delta_minutes

        if calories_in_interval > 0:
            self.total_calories += calories_in_interval

        return {"calories": round(self.total_calories, 2)}