class RetrieveRate {
  RetrieveRate._();

  static int countTotalValues(dynamic model) {
    int totalCount = 0;

    void countNullEmptyValues(dynamic value) {
      if (value is List) {
        for (var item in value) {
          countNullEmptyValues(item);
        }
      } else if (value is Map) {
        for (var entry in value.entries) {
          countNullEmptyValues(entry.value);
        }
      } else if (value == null || value.toString().trim().isEmpty) {
      }
      totalCount++;
    }

    countNullEmptyValues(model);

    return totalCount;
  }


  static int countNullEmptyValues(dynamic model) {
    int count = 0;
    if (model is List) {
      for (var item in model) {
        count += countNullEmptyValues(item);
      }
    } else if (model is Map) {
      for (var entry in model.entries) {
        count += countNullEmptyValues(entry.value);
      }
    } else if (model == null || model.toString().trim().isEmpty) {
      count++;
    }
    return count;
  }

}
