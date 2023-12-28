enum Value { small, medium, large }

String toString(Value v) {
  switch (v) {
    case Value.large:
      return "Large";
    case Value.medium:
      return "Medium";
    case Value.small:
      return "Small";
  }
}

typedef StoryPoints = int;
