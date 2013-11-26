class PathPoint < ActiveRecord::Base
  belongs_to :path, inverse_of: :path_points


  def self.new_from_csv(row)
    path_id = Uuid.get_id Path.uuid_namespace, row[:shape_id]
    if path_id.nil?
      path = Path.new
      path.build_uuid uuid: Uuid.create(Path.uuid_namespace, row[:shape_id]).raw
      path.save
      path_id = path.id
    end

    PathPoint.new path_id: path_id, lat: row[:shape_pt_lat].to_f, lng: row[:shape_pt_lon].to_f,
                  index: row[:shape_pt_sequence].to_i
  end
end
