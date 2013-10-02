module DatabaseOps
  def save
    # p columns
    # p column_vals

    inst_vars = self.instance_variables - [:@id, :@table_name]
    columns =  (inst_vars.map {|inst| inst.to_s[1..-1] })
    column_vals =  inst_vars.map {|inst| self.send(inst[1..-1].to_sym) }

    if self.id.nil?
      create(column_vals, columns, @table_name)
    else
      update(column_vals, columns, @table_name)
    end
  end

  private
  def create(column_vals, columns,table)
    raise "already saved!" unless self.id.nil?
    QuestionsDatabase.instance.execute(<<-SQL, *column_vals)
    INSERT INTO #{table} (#{columns.join(", ")})
    VALUES
      (#{"?, " * (columns.length-1) + "?"})
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update(column_vals, columns, table)
    results = QuestionsDatabase.instance.execute(<<-SQL, *column_vals, self.id)
      UPDATE #{table}
      SET #{columns.join(" = ?, ") + " = ?"}
      WHERE id = ?
    SQL

    self.id
  end


end