helpers do
  def _build_track(track_length)
    track = "<td class="active"></td>"
    2.upto(track_length) do
      track += "<td></td>"
    end
    track
  end
end
